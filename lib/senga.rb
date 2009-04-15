require 'RMagick'

# Make a new graph:
#   graph = Senga.new
# Plot a couple of lines:
#   graph.plot('blue', [1, 2, 3])
#   graph.plot('#ff00ff', [3, 2, 1], 2)
# Render it:
#   image = graph.render(:xscale => 3, :yscale => 20)
# There are probably other things you'll want to do with that, like this:
#   File.open('some-graph.png', 'w') { |f| f.write image.to_blob }
class Senga
	# Render has it some options.
	DefaultRenderOpts = {
		:xscale => nil,
		:yscale => nil,
		:width => nil,
		:height => nil,
		:stroke_width => 1,
		:format => 'PNG',
		:bgcolor => 'transparent',
	}

	def self.graph(opts = {}, &b)
		g = new
		b.call g
		g.render opts
	end

	def plots
		@plots ||= []
	end

	def plot(*a)
		plots << a
	end

	# Render has it some options.  See Senga::DefaultRenderOpts.
	def render opts = {}
		opts = sanitize_opts opts
		coords = data_coords opts[:xscale], opts[:yscale], opts[:height]
		image = Magick::Image.new(opts[:width], opts[:height]) {
			self.background_color = opts[:bgcolor]
		}
		image.format = opts[:format]
		draw = Magick::Draw.new
		coords.each { |color,cs,width|
			draw.stroke color
			draw.stroke_width(width || 1)

			cs.inject { |a,b|
				draw.line *[a,b].flatten
				b
			}
		}
		draw.draw image
		image
	end

	private

	def sanitize_opts o
		xmax = plots.inject(0) { |max,p| [max, p[1].size].max }
		raise ArgumentError, "Don't have anything to plot?" if xmax < 2
		ymax = plots.inject(0) { |max,p| [max, p[1].max].max }

		o = DefaultRenderOpts.merge(o).merge(:xmax => xmax, :ymax => ymax)

		if o[:xscale].nil?
			if o[:width].nil?
				o[:width] = xmax
			end
			o[:xscale] = o[:width] / xmax
		end
		o[:width] ||= o[:xscale] * (xmax - 1)

		if o[:yscale].nil?
			if o[:height].nil?
				o[:height] = [ymax, 1].max
			end
			o[:yscale] = o[:height] / ymax
		end
		o[:height] ||= o[:yscale] * ymax

		o
	end

	# Turns the current set of plots into arrays of coordinates.
	def data_coords(xscale, yscale, height)
		plots.map { |c,data,*rest|
			n = 0
			([c] << data.map { |point|
				a = [n, height - (point * yscale)]
				n += xscale
				a
			}) + rest
		}
	end
end
