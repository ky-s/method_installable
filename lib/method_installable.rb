require "method_installable/version"

module MethodInstallable
  # klass に指定した class の持つ instance_methods をすべて定義します。
  # converter に指定したメソッドで自身を klass に変換してから対象のメソッドをコールするようになります。
  # 自身が持っているメソッドと名称が重複した場合は自身のメソッドが優先されます。
  # インストール後に追加されたメソッドも method_added イベントによって追随しますが、
  # 削除、未定義にされたメソッドは追随しません。
  # 削除されたメソッドが install_methods_from によって追加されたメソッドかどうかを判定できないためです。
  #
  # [args]
  # klass           ... インストール元クラスオブジェクト
  # converter       ... 現在のオブジェクトを klass オブジェクトに変換するメソッド
  # converter_args  ... converter の引数オプション
  # methods         ... インストールする対象メソッド (default: 全インスタンスメソッド)
  # follow          ... 今後追加したメソッドに追随するか。
  #                     default は、 methods が明示的に渡されたら false 、なければ true です。
  # callback        ... 処理後に実行するコールバックメソッド (Proc も可)
  def install_methods_from(klass, converter, *converter_args, methods: nil, follow: methods.nil?, callback: nil)
    (Array(methods || klass.instance_methods) - self.instance_methods).each do |method|
      install_method_from(klass, converter, *converter_args, method: method, callback: callback)
    end

    if follow
      install_class = self
      # prepend module that has method_added with add the method to self, too.
      klass.singleton_class.prepend(
        Module.new do
          define_method :method_added do |method|
            install_class.install_method_from(klass, converter, *converter_args, method: method, callback: callback)
            super(method)
          end
        end
      )
    end
  end

  # install only one method
  # klass           ... インストール元クラスオブジェクト
  # converter       ... 現在のオブジェクトを klass オブジェクトに変換するメソッド
  # converter_args  ... converter の引数オプション
  # methods         ... インストールする対象メソッド (default: 全インスタンスメソッド)
  # callback        ... 処理後に実行するコールバックメソッド (Proc も可)
  def install_method_from(klass, converter, *converter_args, method: , callback: nil)
    if self.instance_methods.include?(method)
      STDERR.puts "WARNING: #{self}##{method} is already exists. #{self} was not intalled #{klass}##{method}."
      return
    end

    define_method method do |*args|
      result = send(converter, *converter_args).send(method, *args)

      if callback.is_a?(Proc)
        callback.call result
      elsif callback.is_a?(Symbol) || callback.is_a?(String)
        result.send(callback)
      else
        result
      end
    end
    # puts "#{self}##{method} installed from #{klass}."
  end
end
