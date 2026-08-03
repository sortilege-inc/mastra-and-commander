# frozen_string_literal: true

# Mastra trading-card build pipeline (Squib).
#
#   bundle exec ruby cards/deck.rb              # render all cards
#   GUIDES=1 bundle exec ruby cards/deck.rb     # overlay the bleed/trim/zone guides
#   TONE=ink bundle exec ruby cards/deck.rb     # ink pips instead of colour
#
# Geometry is the "Lens" frame system in svg/v3/lens/ (spec.json). Canvas is the
# full-bleed 825×1125 @ 300dpi (2.75×3.75in; 2.5×3.5in trim). Every layer is
# placed at its spec.json origin; text and pips sit on top at the design coords.

require 'squib'
require 'yaml'

ROOT = File.expand_path('..', __dir__)
LENS = 'svg/v3/lens'
DPI  = 300
TONE = (ENV['TONE'] || 'color')           # 'color' | 'ink'
GUIDES = ENV['GUIDES'] == '1'

# --- load content (list-of-hashes YAML → column arrays Squib wants) -----------
raw = YAML.load_file(File.join(ROOT, 'cards', 'cards.yml')) || []
raise 'cards.yml is empty' if raw.empty?
cards = raw.map { |h| h.transform_keys(&:to_sym) }

col = ->(key) { cards.map { |c| c[key] } }

# --- helpers -----------------------------------------------------------------
# Design sizes are CSS px on the 825×1125 canvas. Squib font sizes are points at
# the deck dpi, so px → pt is × 72 / dpi.
pt = ->(px) { (px * 72.0 / DPI).round(2) }
esc = ->(s) { s.to_s.gsub('&', '&amp;').gsub('<', '&lt;').gsub('>', '&gt;') }

# Cost pip centres down the left crescent (spec.json "pips"); pip art is 76×76,
# so top-left = centre − 38.
PIP_CENTERS = [[196, 206], [150, 300], [130, 398], [132, 496], [150, 594]].freeze
PIP_R = 38

def indices_where(list)
  list.each_index.select { |i| yield list[i] }
end

Dir.chdir(ROOT) do
  Squib::Deck.new(width: 825, height: 1125, cards: cards.size, dpi: DPI) do
    # 1. base stock
    svg file: "#{LENS}/card-base.svg", x: 0, y: 0, width: 825, height: 1125

    # 2. art — real art clipped to the lens aperture, else the placeholder.
    #    (art clipping wired in when real art arrives; placeholder is self-shaped.)
    cards.each_with_index do |c, i|
      if c[:art] && !c[:art].to_s.empty?
        # aperture-mask.svg is the lens alpha; art fills that window at 61,61.
        png file: "art/#{c[:art]}", range: i, x: 61, y: 61, width: 703, height: 1003,
            mask: "#{LENS}/aperture-mask.svg"
      else
        svg file: "#{LENS}/art-placeholder.svg", range: i, x: 61, y: 61, width: 703, height: 1003
      end
    end

    # 3. frame (runs under every plate; art bleeds off the right corners)
    svg file: "#{LENS}/frame.svg", x: 47, y: 47, width: 731, height: 1031

    # 4. plates
    svg file: "#{LENS}/title-plate.svg", x: 56, y: 42,  width: 712, height: 174
    svg file: "#{LENS}/type-bar.svg",    x: 56, y: 684, width: 712, height: 146
    svg file: "#{LENS}/textbox.svg",     x: 56, y: 760, width: 712, height: 302

    # 5. stat badge — only on cards that declare a stat
    stat_rows = (0...cards.size).select { |i| cards[i][:stat] && !cards[i][:stat].to_s.empty? }
    unless stat_rows.empty?
      svg file: "#{LENS}/stat-badge.svg", range: stat_rows, x: 528, y: 930, width: 240, height: 136
    end

    # 6. text -----------------------------------------------------------------
    # title
    text str: col.call(:name), font: "Cinzel SemiBold #{pt.call(42)}", color: '#1F2730',
         x: 170, y: 84, width: 530, height: 96, valign: :middle,
         hint: (GUIDES ? '#f0f' : nil)
    # type line
    text str: col.call(:type), font: "Cinzel Medium #{pt.call(30)}", color: '#1F2730',
         x: 112, y: 724, width: 480, height: 66, valign: :middle
    # rules + italic flavor (Pango markup so the flavor colours/italicises inline)
    rules_markup = cards.map do |c|
      body = esc.call(c[:rules]).strip
      if c[:flavor] && !c[:flavor].to_s.empty?
        "#{body}\n\n<span foreground=\"#445353\"><i>#{esc.call(c[:flavor]).strip}</i></span>"
      else
        body
      end
    end
    text str: rules_markup, markup: true, font: "Cormorant Garamond #{pt.call(29)}",
         color: '#1F2730', x: 102, y: 826, width: 614, height: 200, spacing: pt.call(4)
    # stat value
    unless stat_rows.empty?
      text str: col.call(:stat), range: stat_rows, font: "Bebas Neue #{pt.call(52)}",
           color: '#1F2730', x: 548, y: 956, width: 200, height: 88,
           align: :center, valign: :middle
    end
    # artist / credit — italic via Pango <i> markup (a "…Italic" family string
    # doesn't match and falls back to Noto; the <i> tag selects the italic face).
    credit = cards.map do |c|
      line = c[:artist] && !c[:artist].to_s.empty? ? "#{esc.call(c[:artist])} · Mastra © 2026" : 'Mastra © 2026'
      "<i>#{line}</i>"
    end
    text str: credit, markup: true, font: "Cormorant Garamond #{pt.call(21)}", color: '#445353',
         x: 104, y: 996, width: 400

    # 7. cost pips along the crescent
    cards.each_with_index do |c, i|
      Array(c[:cost]).first(5).each_with_index do |res, slot|
        cx, cy = PIP_CENTERS[slot]
        svg file: "svg/08-pips/#{TONE}/pip-#{res}.svg", range: i,
            x: cx - PIP_R, y: cy - PIP_R, width: 76, height: 76
      end
    end

    # 8. optional guides overlay
    svg(file: "#{LENS}/guides.svg", x: 0, y: 0, width: 825, height: 1125) if GUIDES

    # --- output ------------------------------------------------------------
    save_png dir: 'output', prefix: 'card_'
    save_pdf file: 'mastra_cards.pdf', dir: 'output', trim: 37.5, trim_radius: 40
  end
end
