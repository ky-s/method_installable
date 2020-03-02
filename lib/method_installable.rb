require "method_installable/version"
require "method_installable/logger"

module MethodInstallable
  # Define `methods` from `klass` class.
  #
  # The methods implementation:
  #   Firstly, call `converter(*converter_args)` to convert to `klass`.
  #   And then, call 'installed' method from `klass`.
  #
  # If self class has already the method, that is not defined.
  #
  # follow:
  #   follow when method is added to klass.
  #   But not follow when method is removed or undefined.
  #
  # callback:
  #   Proc, Method Object or method its after callback.
  #
  def install_methods_from(
    klass,                # source class for install
    converter,            # method for self convert to klass
    *converter_args,      # converter method arguments
    methods: nil,         # methods for install (default: all instance methods)
    follow: methods.nil?, # follow when method is added to klass
    callback: nil         # after callback method or procedure
  )
    methods_for_intall =
      Array(methods || klass.instance_methods) - self.instance_methods

    methods_for_intall.each do |method|
      install_method_from(
        klass,
        converter,
        *converter_args,
        method: method,
        callback: callback
      )
    end

    if follow
      install_class = self

      # prepend module that has method_added with add the method to self, too.
      klass.singleton_class.prepend(
        Module.new do
          define_method :method_added do |method|

            install_class.install_method_from(
              klass,
              converter,
              *converter_args,
              method: method,
              callback: callback
            )

            super(method)
          end
        end
      )
    end
  end

  # install only one method
  def install_method_from(
    klass,           # source class for install
    converter,       # method for self convert to klass
    *converter_args, # converter method arguments
    method: ,        # method for install
    callback: nil    # after callback method or procedure
  )
    if self.instance_methods.include?(method)
      logger = MethodInstallable::Logger.new
      logger.puts "WARNING: #{self}##{method} is already exists. #{self} was not intalled #{klass}##{method}."
      return
    end

    define_method method do |*args|
      result = send(converter, *converter_args).send(method, *args)

      if callback.is_a?(Proc) || callback.is_a?(Method)
        callback.call result
      elsif callback.is_a?(Symbol) || callback.is_a?(String)
        result.send(callback)
      else
        result
      end
    end
    # STDOUT.puts "#{self}##{method} installed from #{klass}."
  end
end
