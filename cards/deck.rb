# frozen_string_literal: true

# Mastra & Commander — card build pipeline (Squib), Ice Chrome family.
#
#   bundle exec ruby cards/deck.rb              # render all cards
#   ONLY=Agent bundle exec ruby cards/deck.rb   # render only matching cards (fast)
#   GUIDES=1 bundle exec ruby cards/deck.rb      # overlay the frame guides
#
# Each card has a `kind` that selects a frame variant under svg/v4/<variant>/
# (spec.json drives layer origins/z, slot centres, text boxes, accent). Icons
# (pips + contribution marks) are generated inline so they render light on the
# dark sockets and dark inline on the light rules panel.

require 'squib'
require 'yaml'
require 'json'

ROOT = File.expand_path('..', __dir__)
V4   = 'svg/v4'
DPI  = 300
GUIDES = ENV['GUIDES'] == '1'

KIND_TO_VARIANT = {
  'operator' => 'ice', 'entropy' => 'entropy', 'eval' => 'eval', 'feature' => 'feature',
  'equipment' => 'equip', 'model' => 'model', 'framework' => 'framework'
}.freeze
SPECS = KIND_TO_VARIANT.values.uniq.each_with_object({}) do |v, h|
  h[v] = JSON.parse(File.read(File.join(ROOT, V4, v, 'spec.json')))
end

# --- content -----------------------------------------------------------------
raw = YAML.load_file(File.join(ROOT, 'cards', 'cards.yml')) || []
raise 'cards.yml is empty' if raw.empty?
cards = raw.map { |h| h.transform_keys(&:to_sym) }
cards.each { |c| c[:kind] ||= 'operator' }

only = ENV['ONLY'].to_s
cards = cards.select { |c| c[:name].to_s.downcase.include?(only.downcase) } unless only.empty?
raise "no cards match ONLY=#{ENV['ONLY']}" if cards.empty?
TOTAL = cards.size

pt  = ->(px) { (px * 72.0 / DPI).round(2) }
esc = ->(s) { s.to_s.gsub('&', '&amp;').gsub('<', '&lt;').gsub('>', '&gt;') }

# --- icon generators (inline SVG) --------------------------------------------
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
  st = 'stroke="#ffffff" stroke-opacity="0.9" stroke-width="2.5" stroke-linejoin="round"'
  up = -Math::PI / 2
  body = case shape.to_s
         when 'square'   then %(<rect x="10" y="10" width="40" height="40" rx="4" fill="#{fill}" #{st}/>)
         when 'triangle' then %(<polygon points="#{poly(3, 30, 33, 25, up)}" fill="#{fill}" #{st}/>)
         when 'pentagon' then %(<polygon points="#{poly(5, 30, 31, 24, up)}" fill="#{fill}" #{st}/>)
         when 'hexagon'  then %(<polygon points="#{poly(6, 30, 30, 24, up)}" fill="#{fill}" #{st}/>)
         else %(<circle cx="30" cy="30" r="22" fill="#{fill}" #{st}/>)
         end
  %(<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">#{body}</svg>)
end
def disc_svg(color)
  %(<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60"><circle cx="30" cy="30" r="18" fill="#{color}" stroke="#ffffff" stroke-opacity="0.85" stroke-width="2.5"/></svg>)
end

# --- eval hand marks (visualise the target pattern) --------------------------
def swatch_svg(color)  # this colour, any shape
  fill = CONTRIB_COLOR[color.to_s] || '#8899aa'
  %(<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60"><rect x="13" y="13" width="34" height="34" rx="9" fill="#{fill}" stroke="#ffffff" stroke-opacity="0.9" stroke-width="2.5"/><circle cx="30" cy="30" r="26" fill="none" stroke="#ffffff" stroke-opacity="0.5" stroke-width="1.8" stroke-dasharray="4 5"/></svg>)
end
def shape_outline_svg(shape)  # any colour, this shape
  st = 'fill="none" stroke="#cfe3ee" stroke-width="4" stroke-linejoin="round"'
  up = -Math::PI / 2
  body = case shape.to_s
         when 'square'   then %(<rect x="11" y="11" width="38" height="38" rx="4" #{st}/>)
         when 'triangle' then %(<polygon points="#{poly(3, 30, 33, 24, up)}" #{st}/>)
         when 'pentagon' then %(<polygon points="#{poly(5, 30, 31, 23, up)}" #{st}/>)
         when 'hexagon'  then %(<polygon points="#{poly(6, 30, 30, 23, up)}" #{st}/>)
         else %(<circle cx="30" cy="30" r="21" #{st}/>)
         end
  %(<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">#{body}</svg>)
end
def ban_svg(color)  # this colour is forbidden
  fill = CONTRIB_COLOR[color.to_s] || '#8899aa'
  %(<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60"><circle cx="30" cy="30" r="19" fill="#{fill}" fill-opacity="0.85"/><line x1="15" y1="45" x2="45" y2="15" stroke="#ff5555" stroke-width="5.5" stroke-linecap="round"/></svg>)
end
def anymark_svg  # any contribution
  %(<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60"><circle cx="30" cy="30" r="19" fill="none" stroke="#9fb4c2" stroke-width="4" stroke-dasharray="3.5 4.5"/></svg>)
end
def hand_svg(token)
  t = token.to_s
  return ban_svg(t[1..]) if t.start_with?('!')
  return anymark_svg if t == '*' || t == '*/*'
  color, shape = t.split('/')
  return shape_outline_svg(shape) if color == '*'
  return swatch_svg(color) if shape.nil? || shape == '*'
  contrib_svg(color, shape)
end

# --- feature effect glyphs ---------------------------------------------------
def effect_svg(token, color)
  t = token.to_s
  return pip_svg(t.split('/', 2)[1], color) if t.start_with?('grant/')
  body = case t
         when 'shield'
           %(<path d="M50 20 L76 30 V52 C76 70 62 80 50 84 C38 80 24 70 24 52 V30 Z" fill="none" stroke="#{color}" stroke-width="6.5" stroke-linejoin="round"/><path d="M40 52 L48 60 L64 42" fill="none" stroke="#{color}" stroke-width="6.5" stroke-linecap="round" stroke-linejoin="round"/>)
         when 'fork'  # one process branching into two (Parallelism)
           %(<g stroke="#{color}" stroke-width="6.5" stroke-linecap="round" stroke-linejoin="round"><path d="M50 30 V50 M50 50 L30 72 M50 50 L70 72" fill="none"/><circle cx="50" cy="26" r="6" fill="#{color}"/><circle cx="30" cy="76" r="6" fill="#{color}"/><circle cx="70" cy="76" r="6" fill="#{color}"/></g>)
         else # draw
           %(<g fill="none" stroke="#{color}" stroke-width="6.5" stroke-linejoin="round" stroke-linecap="round"><rect x="30" y="26" width="40" height="52" rx="6"/><path d="M50 70 V42 M40 52 L50 42 L60 52"/></g>)
         end
  %(<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100">#{body}</svg>)
end

ICON_ALIASES = {
  'coin' => 'capital', 'capital' => 'capital', 'value' => 'capital',
  'eye' => 'attention', 'attention' => 'attention',
  'gear' => 'technology', 'technology' => 'technology', 'automation' => 'technology',
  'blank' => 'generic', 'generic' => 'generic', 'wild' => 'generic'
}.freeze
rich = lambda do |raw_text|
  s = esc.call(raw_text).strip
  s = s.gsub(/\*\*(.+?)\*\*/m) { "<b>#{Regexp.last_match(1)}</b>" }
  s = s.gsub(/\*(.+?)\*/m) { "<i>#{Regexp.last_match(1)}</i>" }  # single-asterisk italics (keywords)
  s.gsub(/\{([a-z]+)\}/) { (a = ICON_ALIASES[Regexp.last_match(1)]) ? "{{#{a}}}" : Regexp.last_match(0) }
end

ICE_LIGHT = '#eaffff'  # pips on dark sockets
INK       = '#1a3441'  # pips inline on the light panel
PIP_SIZE  = 46
CON_SIZE  = 44

# text-box helper: draw one text-box (from spec) across a card range
def font_str(f)
  weight = { 700 => 'Bold', 600 => 'SemiBold', 500 => 'Medium', 400 => '' }[f['weight']] || ''
  "#{f['family']} #{weight}".strip
end

Dir.chdir(ROOT) do
  Squib::Deck.new(width: 825, height: 1125, cards: TOTAL, dpi: DPI) do
    names     = cards.map { |c| c[:name].to_s.upcase }
    traits    = cards.map { |c| Array(c[:traits]).join(' · ').upcase }
    rules_col = cards.map { |c| c[:rules] }
    collector = (0...TOTAL).map { |i| format('%03d/%03d', i + 1, TOTAL) }

    by_kind = (0...TOTAL).group_by { |i| cards[i][:kind] }

    by_kind.each do |kind, idxs|
      v = KIND_TO_VARIANT[kind] || 'ice'
      spec = SPECS[v]
      dir = "#{V4}/#{v}"
      accent = spec['accent']

      # 1. frame layers (z-order; skip the mask; guides only on demand)
      spec['layers']
        .reject { |name, l| l['role'] == 'mask' || (name == 'guides' && !GUIDES) }
        .sort_by { |_n, l| l['z'] }
        .each { |_n, l| svg file: "#{dir}/#{l['file']}", range: idxs, x: l['x'], y: l['y'], width: l['w'], height: l['h'] }

      tbx = spec['textBoxes']

      # 2. title (autoscale shrinks long names to fit instead of ellipsizing)
      t = tbx['title']
      text str: names, range: idxs, font: "#{font_str(t['font'])} #{pt.call(t['font']['size'])}",
           color: t['font']['color'], x: t['x'], y: t['y'], width: t['w'], height: t['h'],
           align: :center, valign: :middle, ellipsize: :autoscale

      # 3. traits (subtitle plate)
      if (tr = tbx['traits'])
        text str: traits, range: idxs, font: "#{font_str(tr['font'])} #{pt.call(tr['font']['size'])}",
             color: tr['font']['color'], x: tr['x'], y: tr['y'], width: tr['w'], height: tr['h'],
             align: :center, valign: :middle, ellipsize: :autoscale
      end

      # 4. rules (with inline pip icons)
      r = tbx['rules']
      markup = cards.map { |c| rich.call(c[:rules]) }
      text(str: markup, range: idxs, markup: true, font: "#{font_str(r['font'])} #{pt.call(r['font']['size'])}",
           color: r['font']['color'], x: r['x'], y: r['y'], width: r['w'], height: r['h'],
           valign: :top, spacing: pt.call(7)) do |embed|
        %w[capital attention technology generic].each do |res|
          embed.svg key: "{{#{res}}}", data: pip_svg(res, INK), width: 30, height: 30, dy: -22
        end
      end

      # 5. collector card number
      if (cx = tbx['collector'])
        text str: collector, range: idxs, font: "#{font_str(cx['font'])} #{pt.call(cx['font']['size'])}",
             color: cx['font']['color'], x: cx['x'], y: cx['y'], width: cx['w'], height: cx['h'],
             align: :right, valign: :middle
      end

      # 6. entropy: the wrench vector
      if (vb = tbx['vector'])
        vec = cards.map { |c| Array(c[:traits]).first.to_s.upcase }
        text str: vec, range: idxs, font: "#{font_str(vb['font'])} #{pt.call(vb['font']['size'])}",
             color: vb['font']['color'], x: vb['x'], y: vb['y'], width: vb['w'], height: vb['h'],
             align: :center, valign: :middle
      end

      # 7. eval: par number
      if (pb = tbx['par'])
        par = cards.map { |c| c[:par].to_s }
        text str: par, range: idxs, font: "#{font_str(pb['font'])} #{pt.call(pb['font']['size'])}",
             color: pb['font']['color'], x: pb['x'], y: pb['y'], width: pb['w'], height: pb['h'],
             align: :center, valign: :middle
      end

      slots = spec['slots'] || {}
      # 8. per-card slot icons
      idxs.each do |i|
        c = cards[i]
        # pip slot groups
        { 'produce' => c[:produce], 'consume' => c[:consume], 'grants' => c[:grants] }.each do |grp, list|
          next unless slots[grp]
          Array(list).first(slots[grp].size).each_with_index do |pip, s|
            cx, cy = slots[grp][s]
            svg data: pip_svg(pip, ICE_LIGHT), range: i, x: cx - PIP_SIZE / 2.0, y: cy - PIP_SIZE / 2.0, width: PIP_SIZE, height: PIP_SIZE
          end
        end
        # contribution slot groups
        if slots['contributes']
          Array(c[:contributes]).first(slots['contributes'].size).each_with_index do |cs, s|
            color, shape = cs.to_s.split('/')
            cx, cy = slots['contributes'][s]
            svg data: contrib_svg(color, shape), range: i, x: cx - CON_SIZE / 2.0, y: cy - CON_SIZE / 2.0, width: CON_SIZE, height: CON_SIZE
          end
        end
        # eval difficulty pips (fill `difficulty` of the small slots with the accent)
        if slots['difficulty'] && c[:difficulty]
          slots['difficulty'].first(c[:difficulty].to_i).each do |cx, cy|
            svg data: disc_svg(accent), range: i, x: cx - 14, y: cy - 14, width: 28, height: 28
          end
        end
        # eval hand strip — illustrative target marks
        if slots['hand'] && c[:hand]
          Array(c[:hand]).first(slots['hand'].size).each_with_index do |tok, s|
            cx, cy = slots['hand'][s]
            svg data: hand_svg(tok), range: i, x: cx - CON_SIZE / 2.0, y: cy - CON_SIZE / 2.0, width: CON_SIZE, height: CON_SIZE
          end
        end
        # feature effect glyph (one large central slot)
        if slots['effect'] && c[:effect]
          cx, cy = slots['effect'][0]
          es = 96
          svg data: effect_svg(c[:effect], ICE_LIGHT), range: i, x: cx - es / 2.0, y: cy - es / 2.0, width: es, height: es
        end
      end
    end

    save_png dir: 'output', prefix: 'card_'
    save_pdf file: 'mastra_cards.pdf', dir: 'output', trim: 37.5, trim_radius: 40
  end
end

# --- card backs (2 shared backs; all-baked, no live text) --------------------
# operator back → every non-entropy deck; entropy back → entropy cards.
BACKS = { 'operator' => "#{V4}/backs/operator", 'entropy' => "#{V4}/backs/entropy" }
Dir.chdir(ROOT) do
  Squib::Deck.new(width: 825, height: 1125, cards: BACKS.size, dpi: DPI) do
    BACKS.values.each_with_index do |dir, i|
      bspec = JSON.parse(File.read(File.join(ROOT, dir, 'spec.json')))
      bspec['layers']
        .reject { |name, _l| name == 'guides' && !GUIDES }
        .sort_by { |_n, l| l['z'] }
        .each { |_n, l| svg file: "#{dir}/#{l['file']}", range: i, x: l['x'], y: l['y'], width: l['w'], height: l['h'] }
    end
    save_png dir: 'output', prefix: 'back_'
  end
end
# clean filenames: back_00 → back_operator.png, back_01 → back_entropy.png
BACKS.keys.each_with_index do |name, i|
  src = File.join(ROOT, 'output', format('back_%02d.png', i))
  File.rename(src, File.join(ROOT, 'output', "back_#{name}.png")) if File.exist?(src)
end
