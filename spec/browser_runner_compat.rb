# Compatiblity for Opal < 1.6

unless defined? Opal::BuilderProcessors::RubyERBProcessor
  # This handler is for files named ".rb.erb", which ought to
  # first get preprocessed via ERB, then via Opal.
  class Opal::BuilderProcessors::RubyERBProcessor < Opal::BuilderProcessors::RubyProcessor
    handles :"rb.erb"

    def compiled
      @compiled ||= begin
        @source = ::ERB.new(@source.to_s).result
        module_name = ::Opal::Compiler.module_name(@filename)

        compiler = compiler_for(@source, file: @filename)
        compiler.compile
        compiler
      end
    end
  end

  Opal::Builder.processors.sort_by!.with_index do |processor,idx|
    if processor == Opal::BuilderProcessors::RubyERBProcessor
      # Move RubyERBProcessor to the front
      -1
    else
      idx
    end
  end
end
