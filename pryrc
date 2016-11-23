Pry.config.editor = 'vim'

Pry.commands.alias_command 'E', 'exit'
Pry.commands.alias_command 'Q', 'exit-program'
Pry.commands.alias_command 'W', 'whereami'

if defined?(PryDebugger)
  Pry.commands.alias_command 'C', 'continue'
  Pry.commands.alias_command 'S', 'step'
  Pry.commands.alias_command 'N', 'next'
  Pry.commands.alias_command 'F', 'finish'
end

if defined? Rails
  require 'logger'
  Rails.logger =
    ActiveRecord::Base.logger =
    ActionController::Base.logger = Logger.new(STDOUT)
end

# Example:
#     pbcopy large_object.to_json
# You can then paste the JSON result in your favorite editor
def pbcopy(input)
  str = input.to_s
  IO.popen('pbcopy', 'w') { |f| f << str }
  str
end

# Example:
#     str = pbpaste
# The content of your clipboard is now available in `str``
def pbpaste
  `pbpaste`
end

module Benchmark
  # Simple comparison benchmark method
  #
  # Example:
  #
  #    Benchmark.compare(100_000) do |x|
  #      x.join do
  #        ['a', 'b', 'c'].join
  #      end
  #      x.plus do
  #        'a' + 'b' + 'c'
  #      end
  #      x.concat do
  #        'a' << 'b' << 'c'
  #      end
  #    end
  #
  # Output:
  #
  #     Rehearsal ------------------------------------------------
  #     join:          0.260000   0.470000   0.730000 (  1.062799)
  #     plus:          0.160000   0.010000   0.170000 (  0.230257)
  #     concat:        0.040000   0.000000   0.040000 (  0.041604)
  #     --------------------------------------- total: 0.940000sec
  #
  #                        user     system      total        real
  #     join:          0.070000   0.010000   0.080000 (  0.079609)
  #     plus:          0.040000   0.000000   0.040000 (  0.032143)
  #     concat:        0.030000   0.000000   0.030000 (  0.036667)
  def self.compare(times = 1, label_width = 12)
    bmbm(label_width) do |x|
      yield ReportProxy.new(x, times)
    end
  end

  class ReportProxy
    def initialize(bm, iterations)
      @bm, @iterations = bm, iterations
    end

    def method_missing(method, *args, &block)
      args.unshift(method.to_s + ':')
      @bm.report(*args) do
        @iterations.times(&block)
      end
    end
  end
end
