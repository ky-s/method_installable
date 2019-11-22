require "test_helper"

class MethodInstallableTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::MethodInstallable::VERSION
  end

  require "stubs"

  class ::Ditto < Pokemon # メタモン
    extend MethodInstallable

    install_methods_from Pikachu,    :transform
    install_methods_from Clefairy,   :transform, Clefairy,  methods: :tackle
    install_methods_from Togepi,     :transform, Togepi,    methods: :metronome, follow: true
    install_method_from  Tyrogue,    :transform, Tyrogue,   method: :rock_smash, callback: -> (res) { res + '！！' }
    install_method_from  Charizard,  :transform, Charizard, method: :fly

    def transform(klass = Pikachu)
      klass.new(@name)
    end
  end

  # add method after installed
  class ::Pikachu < Pokemon
    def thunder
      fight('かみなり')
    end
  end

  class ::Clefairy < Pokemon
    def barrier
      fight('バリアー')
    end
  end

  class ::Togepi < Pokemon
    def attract
      fight('メロメロ')
    end
  end

  class ::Tyrogue < Pokemon
    def mega_kick
      fight('メガトンキック')
    end
  end

  class ::Charizard < Pokemon
    def fire_blast
      fight('だいもんじ')
    end
  end

  def test_install_methods_from_pikachu
    assert_includes Ditto.instance_methods, :thunderbolt
    assert_includes Ditto.instance_methods, :double_team
    assert_includes Ditto.instance_methods, :thunder
  end

  def test_install_methods_from_clefairy
    assert_includes Ditto.instance_methods, :tackle
    refute Ditto.instance_methods.include?(:double_slap)
    refute Ditto.instance_methods.include?(:barrier)
  end

  def test_install_methods_from_togepi
    assert_includes Ditto.instance_methods, :metronome
    refute Ditto.instance_methods.include?(:encore)
    assert_includes Ditto.instance_methods, :attract
  end

  def test_install_method_from_tyrogue
    assert_includes Ditto.instance_methods, :rock_smash
    refute Ditto.instance_methods.include?(:rapid_spin)
    refute Ditto.instance_methods.include?(:mega_kick)
    assert_match(/！！！$/, Ditto.new('メタモン').rock_smash)
  end

  def test_install_method_from_charizard
    assert_includes Ditto.instance_methods, :fly
    refute Ditto.instance_methods.include?(:flamethrower)
    refute Ditto.instance_methods.include?(:fire_blast)
  end

  def test_the_case_of_call_back_is_a_symbol
    the_c = Charizard.new('my Charizard')
    result_string = the_c.flamethrower

    Dragonite.extend(::MethodInstallable)
    Dragonite.install_method_from ::Charizard, :charizard_converter, method: :flamethrower, callback: :length
    the_d = Dragonite.new('my Dragonite')
    assert_equal result_string.length, the_d.flamethrower
  end

  def test_the_case_of_call_back_is_not_callable
    the_t = Tyrogue.new('my Tyrogue')
    Dragonite.extend(::MethodInstallable)
    Dragonite.install_method_from ::Tyrogue, :tyrogue_converter, method: :rock_smash, callback: 1
    the_d = Dragonite.new('my Dragonite')
    assert_equal the_t.rock_smash, the_d.rock_smash
  end

  class MockIO
    attr_accessor :message
    def puts(message)
      self.message = message
    end
  end

  def test_the_case_method_is_already_exists
    mockIO = MockIO.new
    MethodInstallable::Logger.io = mockIO
    Dragonite.extend(::MethodInstallable)
    Dragonite.install_method_from ::Charizard, :fly, method: :fly
    assert_equal "WARNING: Dragonite#fly is already exists. Dragonite was not intalled Charizard#fly.", mockIO.message
  end
end
