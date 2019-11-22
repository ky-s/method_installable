module MethodInstallable
  # MethodInstallable's logger class
  class Logger
    class << self
      attr_writer :io
      def io
        @io ||= STDERR
      end
    end

    def puts(message)
      Logger.io.puts message
    end
  end
end
