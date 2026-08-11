# frozen_string_literal: true

# Mastra & Commander — card build pipeline (Squib), Ice Chrome frame.
#
#   bundle exec ruby cards/deck.rb              # render all cards
#   ONLY=Agent bundle exec ruby cards/deck.rb   # render only matching cards (fast)
#   GUIDES=1 bundle exec ruby cards/deck.rb      # overlay the frame guides
#
# Geometry is driven by svg/v4/ice/spec.json (layer origins/z, slot centres,
# text boxes). Canvas is 825×1125 @ 300dpi (2.75×3.75in; 2.5×3.5in trim).
# Icons (produce/consume pips + contribution marks) are generated inline so they
# can render light on the dark rail sockets and dark inline on the light panel.

require 'squib'
require 'yaml'
require 'json'

ROOT = File.expand_path('..', __dir__)
ICE  = 'svg/v4/ice'
DPI  = 300
GUIDES = ENV['GUIDES'] == '1'
SPEC = JSON.parse(File.read(File.join(ROOT, ICE, 'spec.json')))

# --- content -----------------------------------------------------------------
raw = YAML.load_file(File.join(ROOT, 'cards', 'cards.yml')) || []
raise 'cards.yml is empty' if raw.empty?
cards = raw.map { |h| h.transform_keys(&:to_sym) }

only = ENV['ONLY'].to_s
cards = cards.select { |c| c[:name].to_s.downcase.include?(only.downcase) } unless only.empty?
raise "no cards match ONLY=#{ENV['ONLY']}" if cards.empty?

col = ->(key) { cards.map { |c| c[key] } }
pt  = ->(px) { (px * 72.0 / DPI).round(2) }
esc = ->(s) { s.to_s.gsub('&', '&amp;').gsub('<', '&lt;').gsub('>', '&gt;') }

# --- icon generators (inline SVG) --------------------------------------------
# Pip glyphs on a 200×200 canvas; %C% is the stroke/fill colour.
PIP_GLYPH = {
  'capital'    => '<path d="M 127 76 C 127 60 114 52 100 52 C 86 52 75 61 75 74 C 75 100 127 96 127 126 C 127 141 114 149 100 149 C 86 149 72 141 72 125" fill="none" stroke="%C%" stroke-width="15" stroke-linecap="round"/><path d="M 100 39 V 162" stroke="%C%" stroke-width="13" stroke-linecap="round"/>',
  'attention'  => '<path d="M 40 100 C 63 66 137 66 160 100 C 137 134 63 134 40 100 Z" fill="none" stroke="%C%" stroke-width="13" stroke-linejoin="round"/><circle cx="100" cy="100" r="22" fill="%C%"/>',
  'technology' => '<path d="M 147.74 94.98 L 162.81 95.06 L 162.81 104.94 L 147.74 105.02 A 48 48 0 0 1 137.30 130.21 L 147.91 140.92 L 140.92 147.91 L 130.21 137.30 A 48 48 0 0 1 105.02 147.74 L 104.94 162.81 L 95.06 162.81 L 94.98 147.74 A 48 48 0 0 1 69.79 137.30 L 59.08 147.91 L 52.09 140.92 L 62.70 130.21 A 48 48 0 0 1 52.26 105.02 L 37.19 104.94 L 37.19 95.06 L 52.26 94.98 A 48 48 0 0 1 62.70 69.79 L 52.09 59.08 L 59.08 52.09 L 69.79 62.70 A 48 48 0 0 1 94.98 52.26 L 95.06 37.19 L 104.94 37.19 L 105.02 52.26 A 48 48 0 0 1 130.21 62.70 L 140.92 52.09 L 147.91 59.08 L 137.30 69.79 A 48 48 0 0 1 147.74 94.98 Z M 100 78 A 22 22 0 1 0 100 122 A 22 22 0 1 0 100 78 Z" fill="%C%" fill-rule="evenodd"/>',
  'generic'    => '<circle cx="100" cy="100" r="44" fill="none" stroke="%C%" stroke-width="13" stroke-dasharray="20 16"/>'
}.freeze
def pip_svg(pip, color)
  glyph = (PIP_GLYPH[pip.to_s] || PIP_GLYPH['generic']).gsub('%C%', color)
  %(<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200" viewBox="0 0 200 200">#{glyph}</svg>)
end

CONTRIB_COLOR = {
  'pink' => '#e0459b', 'cyan' => '#00c2d4', 'amber' => '#e0a52a',
  'violet' => '#7b68d6', 'green' => '#37b26a'
}.freeze
def poly(n, cx, cy, r, rot)
  (0...n).map { |k| a = rot + k * 2 * Math::PI / n
    "#{(cx + r * Math.cos(a)).round(2)},#{(cy + r * Math.sin(a)).round(2)}" }.join(' ')
end
def contrib_svg(color, shape)
  fill = CONTRIB_COLOR[color.to_s] || '#8899aa'
  stroke = 'stroke="#ffffff" stroke-opacity="0.9" stroke-width="2.5" stroke-linejoin="round"'
  up = -Math::PI / 2
  body = case shape.to_s
         when 'circle'   then %(<circle cx="30" cy="30" r="22" fill="#{fill}" #{stroke}/>)
         when 'square'   then %(<rect x="10" y="10" width="40" height="40" rx="4" fill="#{fill}" #{stroke}/>)
         when 'triangle' then %(<polygon points="#{poly(3, 30, 33, 25, up)}" fill="#{fill}" #{stroke}/>)
         when 'pentagon' then %(<polygon points="#{poly(5, 30, 31, 24, up)}" fill="#{fill}" #{stroke}/>)
         when 'hexagon'  then %(<polygon points="#{poly(6, 30, 30, 24, up)}" fill="#{fill}" #{stroke}/>)
         else %(<circle cx="30" cy="30" r="22" fill="#{fill}" #{stroke}/>)
         end
  %(<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">#{body}</svg>)
end

# rules mini-syntax: **bold** + inline pip tokens {gear}{eye}{coin}{blank}
ICON_ALIASES = {
  'coin' => 'capital', 'capital' => 'capital', 'eye' => 'attention', 'attention' => 'attention',
  'gear' => 'technology', 'technology' => 'technology', 'blank' => 'generic', 'generic' => 'generic'
}.freeze
rich = lambda do |raw_text|
  s = esc.call(raw_text).strip
  s = s.gsub(/\*\*(.+?)\*\*/m) { "<b>#{Regexp.last_match(1)}</b>" }
  s.gsub(/\{([a-z]+)\}/) { (a = ICON_ALIASES[Regexp.last_match(1)]) ? "{{#{a}}}" : Regexp.last_match(0) }
end

ICE_LIGHT = '#eaffff'  # pip colour on dark rail sockets
INK       = '#1a3441'  # pip colour inline on the light rules panel
PIP_SIZE  = 46
CON_SIZE  = 44

Dir.chdir(ROOT) do
  Squib::Deck.new(width: SPEC['canvas']['w'], height: SPEC['canvas']['h'], cards: cards.size, dpi: DPI) do
    # 1. frame layers, in z-order (skip the mask; guides only on demand)
    SPEC['layers']
      .reject { |name, l| l['role'] == 'mask' || (name == 'guides' && !GUIDES) }
      .sort_by { |_name, l| l['z'] }
      .each do |_name, l|
        svg file: "#{ICE}/#{File.basename(l['file'])}", x: l['x'], y: l['y'], width: l['w'], height: l['h']
      end

    # 2. title (Chakra Petch Bold, uppercase, centred)
    tb = SPEC['textBoxes']['title']
    text str: col.call(:name).map { |n| n.to_s.upcase }, font: "Chakra Petch Bold #{pt.call(tb['font']['size'])}",
         color: tb['font']['color'], x: tb['x'], y: tb['y'], width: tb['w'], height: tb['h'],
         align: :center, valign: :middle

    # 3. traits — slim line atop the rules panel
    rb = SPEC['textBoxes']['rules']
    traits_line = cards.map { |c| Array(c[:traits]).join('   ·   ').upcase }
    text str: traits_line, font: "Barlow SemiBold #{pt.call(17)}", color: '#0a6f7d',
         x: rb['x'], y: rb['y'] - 4, width: rb['w'], height: 24, align: :left, valign: :middle

    # 4. rules text (Barlow), below the traits line, with inline pip icons
    rules_markup = cards.map { |c| rich.call(c[:rules]) }
    text(str: rules_markup, markup: true, font: "Barlow #{pt.call(rb['font']['size'])}",
         color: rb['font']['color'], x: rb['x'], y: rb['y'] + 26, width: rb['w'], height: rb['h'] - 26,
         valign: :top, spacing: pt.call(7)) do |embed|
      %w[capital attention technology generic].each do |res|
        embed.svg key: "{{#{res}}}", data: pip_svg(res, INK), width: 30, height: 30, dy: -22
      end
    end

    # 5. icons on the rails — produce (left), consume (right), contributes (bottom)
    cards.each_with_index do |c, i|
      Array(c[:produce]).first(5).each_with_index do |pip, slot|
        cx, cy = SPEC['slots']['produce'][slot]
        svg data: pip_svg(pip, ICE_LIGHT), range: i, x: cx - PIP_SIZE / 2.0, y: cy - PIP_SIZE / 2.0, width: PIP_SIZE, height: PIP_SIZE
      end
      Array(c[:consume]).first(5).each_with_index do |pip, slot|
        cx, cy = SPEC['slots']['consume'][slot]
        svg data: pip_svg(pip, ICE_LIGHT), range: i, x: cx - PIP_SIZE / 2.0, y: cy - PIP_SIZE / 2.0, width: PIP_SIZE, height: PIP_SIZE
      end
      Array(c[:contributes]).first(3).each_with_index do |cs, slot|
        color, shape = cs.to_s.split('/')
        cx, cy = SPEC['slots']['contributes'][slot]
        svg data: contrib_svg(color, shape), range: i, x: cx - CON_SIZE / 2.0, y: cy - CON_SIZE / 2.0, width: CON_SIZE, height: CON_SIZE
      end
    end

    save_png dir: 'output', prefix: 'card_'
    save_pdf file: 'mastra_cards.pdf', dir: 'output', trim: 37.5, trim_radius: 40
  end
end
