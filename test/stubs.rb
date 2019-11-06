class Pokemon
  def initialize(name)
    @name = name
  end

  def fight(move)
    "#{@name}　の　#{move}！"
  end
end

class Pikachu < Pokemon
  def thunderbolt
    fight('10まんボルト')
  end

  def double_team
    fight('かげぶんしん')
  end
end

class Clefairy < Pokemon # ピッピ
  def tackle
    fight('たいあたり')
  end

  def double_slap
    fight('おうふくビンタ')
  end
end

class Togepi < Pokemon
  def metronome
    fight('ゆびをふる')
  end

  def encore
    fight('アンコール')
  end
end

class Tyrogue < Pokemon # バルキー
  def rock_smash
    fight('いわくだき')
  end

  def rapid_spin
    fight('こうそくスピン')
  end
end

class Charizard < Pokemon # リザードン
  def flamethrower
    fight('かえんほうしゃ')
  end

  def fly
    fight('そらをとぶ')
  end
end
