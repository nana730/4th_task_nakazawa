require_relative 'ownable'#ownerを読み込む

class Wallet
  include Ownable
  attr_reader :balance

  def initialize(owner)
    self.owner = owner #selfはクラス自体(Wallet)を表す"tanaka"だったら、Wallet.tanakaになる
    @balance = 0
  end

  def deposit(amount)
    @balance += amount.to_i
  end

  def withdraw(amount)
    return unless @balance >= amount
    @balance -= amount.to_i
    amount
  end

end