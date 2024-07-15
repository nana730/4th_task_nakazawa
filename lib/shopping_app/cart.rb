require_relative "ownable"
require_relative "item_manager"

class Cart
  include ItemManager
  include Ownable

  def initialize(owner)
    self.owner = owner #Cart= self
    @items = [] #アイテムが入ってる
  end

  def items
    # Cartにとってのitemsは自身の@itemsとしたいため、ItemManagerのitemsメソッドをオーバーライドします。
    # CartインスタンスがItemインスタンスを持つときは、オーナー権限の移譲をさせることなく、自身の@itemsに格納(Cart#add)するだけだからです。
    @items
  end

  def add(item)
    @items << item
  end

  def total_amount
    @items.sum(&:price)
  end

  def check_out
    return if owner.wallet.balance < total_amount
  # ## 要件
  #   - カートの中身（Cart#items）のすべてのアイテムの購入金額が、カートのオーナーのウォレットからアイテムのオーナーのウォレットに移されること。
  #   - カートの中身（Cart#items）のすべてのアイテムのオーナー権限が、カートのオーナーに移されること。
  #    - カートの中身（Cart#items）が空になること。
    @items.each do |item|
    self.owner.wallet.withdraw(item.price) #withdrawメソッドでdipositからitem.price金額を引き抜く,self=ownerのCart
    item.owner.wallet.deposit(item.price)
    item.owner = owner
    end
    # owner.wallet.balance += 
    @items = []
  
  # ## ヒント
  #   - カートのオーナーのウォレット ==> self.owner.wallet
  #   - アイテムのオーナーのウォレット ==> item.owner.wallet
  #   - お金が移されるということ ==> cutomer(？)のウォレットからtotalした金額(?)その分を引き出して、seller(？)のウォレットにその分を入金するということ
  #   - アイテムのオーナー権限がカートのオーナーに移されること ==> オーナーの書き換え(item.owner = ?)
  end
end
