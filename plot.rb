# Ruby Plotting Program

PI = 3.1415926535897932384626433832795 #Pie
INFINITY = 10**14 # 100 billion limit of ruby float
E = (1.0+(1.0/INFINITY))**INFINITY #Eulars Number
#trig functions
def arctan(x)
	Math.atan(x).to_f.indeg
end
def cosine(angle)
	Math.cos(angle.to_f).to_f
end
def sine(angle)
	Math.sin(angle.to_f).to_f
end
class Float
		#rounding function
		def chop(decimal=2)
			(self * 10**decimal).round.to_f / 10**decimal
		end
		#charactor counter for float variables
		def digits
			self.to_s.length
		end
		def inrads
			PI*self/180
		end
		def indeg
			180*self/PI
		end
end
class Array
	def keys
	
		i = 0
		a = []
		while i <= (self.length-1)
			a[i] = self[i][0]
			i += 1
		end
		return a
	end
	def values
		i = 0
		a = []
		while i <= (self.length-1)
			a[i] = self[i][1]
			i += 1
		end
		return a
	end
end
class Function 
	attr_reader :func, :scale, :domain, :range
	attr_writer :func, :scale, :domain, :range
	def initialize(func)
		@func = func
	end
	def f(x)
		eval(@func)
	end
	def dydx(x)
		m = (f(x)-f(x-1.0/INFINITY))/(x-(x-1.0/INFINITY))
	end	
	def integral(a = @domain[0],b = @domain[1])
		@a = a
		@n = 10000.0
		@w = (b - a)/@n
		odd, even = 0.0, 0.0
		def x(strip)
			x = @a + strip*@w
		end
		s = 1
		while s < @n
			odd += f(x(s))
			s += 2
		end
		s = 2
		while s < @n
			even += f(x(s))
			s += 2
		end
		area = (@w/3.0)*(f(x(0)) + f(x(@n)) + 4.0*odd + 2.0*even)
	end
	def invert 
		@list = @list.reverse
	end
	def hash
		f = {}
		x = @domain[0]
		while x <= @domain[1]
			f[x] = f(x)
			x += @scale
		end
		@list = f.sort
		@hash = f
		return @hash
	end
	def array
		return @list
	end
	def tabulate_y
		hash
		border
		y_row
		border
		x_row
		border
	end
	def tabulate_dydx
		hash_dydx
		border
		y_row
		border
		x_row
		border
	end
	def tabulate_integral
		hash_integral
		border
		y_row
		border
		x_row
		border
	end
	def border
		line = "|-------|"
		@list.each do |x, y|
			dig = [x.to_f.chop.digits,y.to_f.chop.digits,dydx(x).chop.digits]
			line += "-"*(dig.max+2) + "|"
		end
		puts line
	end
	def dydx_row
		dline = "| dy/dx |"
		@list.each do |x, y|
			dig = [x.chop.digits,y.chop.digits,dydx(x).chop.digits]
			if dig.max == dig[2]
				dline += " #{dydx(x).chop} |"
			else
				dline += " #{" "*(dig.max-dig[2]) + dydx(x).chop.to_s} |"
			end
		end
		puts dline
	end
	def x_row
		xline = "|   x   |"
		@list.each do |x, y|
			dig = [x.chop.digits,y.chop.digits,dydx(x).chop.digits]
			if dig.max == dig[0]
				xline += " #{x} |"
			else
				xline += " #{" "*(dig.max-dig[0]) + x.chop.to_s} |"
			end
		end
		puts xline
	end
	def y_row
		yline = "|   y   |"
		@list.each do |x, y|
			dig = [x.chop.digits,y.chop.digits,dydx(x).chop.digits]
			if dig.max == dig[1]
				yline += " #{y.chop} |"
			else
				yline += " #{" "*(dig.max-dig[1]) + y.chop.to_s} |"
			end
		end
		puts yline
	end
	def index(x)
		(x*@xBox).to_i
	end
	def hash_dydx
		f = {}
		x = @domain[0]
		while x <= @domain[1]
			f[x] = dydx(x)
			x += @scale
		end
		@list = f.sort
		@hash = f
		@range[1] = @hash[@domain[1]]
	end
	def plot_dydx
		hash_dydx
		plot
	end
	def hash_integral
		f = {}
		x = @domain[0]
		while x <= @domain[1]
			f[x] = integral(@domain[0],x)
			x += @scale
		end
		@list = f.sort
		@hash = f
		#p @hash
	end
	def plot_integral
		hash_integral
		plot
	end
	def tangent(x)
		#y = mx + c
		#c = y - mx
		c = f(x) - dydx(x)*x
		if c > 0
			sign = "+"
		else
			sign = ''
		end
		puts "y = " + dydx(x).chop.to_s + "x" + sign + c.chop.to_s
	end
	def stationary(a,b)
		x = b
		if dydx(a)*dydx(b) < 0
			until dydx(x) < 1.0/INFINITY and dydx(x) > -1.0/INFINITY
				c = (a+b)/2.0
				if dydx(c)*dydx(b) < 0
					a = c
				else 
					b = c
				end
				x = (a+b)/2.0
			end
		else
			puts "Redefine Interval"
		end
		return x
	end	
	def zero(a,b)
		x = b
		if f(a)*f(b) < 0
			until f(x) < 1.0/INFINITY and f(x) > -1.0/INFINITY
				c = (a+b)/2.0
				if f(c)*f(b) < 0
					a = c
				else 
					b = c
				end
				x = (a+b)/2.0
			end
		else
			puts "Redefine Interval"
		end
		return x
	end
	def plot_y
		hash
		plot
	end
	def pos(x)
		(@y[x]*@yBox).to_i
	end
	def plus(x)
		if x > 0
		return x
		end
		0
	end
	def dot(x)
				'.'
			end
	def plot(ylines = 40, xchars = 120)
		
		puts "\n\n"+' '*((xchars/2)-5) + 'f(x) vs. x' + ' '*((xchars/2)-5)
		@dot = '<>'
		@yLines = ylines.to_i
		@range[1] = range[1].to_f
		@domain[1] = @domain[1].to_f
		@xChars = xchars.to_i
		@yWidth = @range[1]/@yLines.to_f
		@xWidth = @domain[1]/@xChars.to_f
		@xBox = 1.0/@xWidth
		@yBox = @yWidth**(-1)
		@x = @list.keys
		@y = @hash	
		@leftBorder = "|"
		@row = []
		@track = []
		def left_margin(i)
			" "*((@range[1].digits+1)-(i*@yWidth).chop.digits) + (i*@yWidth).chop.to_s
		end
		i = 0
		while i <= @yLines
			@row[i] =  left_margin(i) + @leftBorder
			i += 1
		end
		for x in @x
			if @y[x] < @range[1] and @y[x] > @range[0]
				if x > 0
			
					@row[pos(x)] += " "*plus((index(x-@track[pos(x)].to_f))-1) + dot(x)
				else
					@row[pos(x)] += " "*plus((index((x-@track[pos(x)].to_f)-@domain[0]))-1) + dot(x)
				end
			end
			@track[pos(x)] = x
		end
		i = @yLines
		while i >= 0
			puts @row[i]
			i -= 1
		end
		puts " "*(@range[1].digits+1) + "*" + "-"*(@xChars-1)
		puts " "*(@range[1].digits+1) + " "*(@xChars-1) + @domain[1].to_i.to_s
		
	end
end



y = Function.new('x*x')
y.domain = 0.0,5.0
y.range = 0,5.0
y.scale = 0.125
y.plot_y
y.plot_dydx
y.plot_integral
