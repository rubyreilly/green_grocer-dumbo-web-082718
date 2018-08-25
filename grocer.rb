require 'pry'

def consolidate_cart(cart)
  consolidated={}
  cart.each do |item_hash|
    item_hash.each do |item_key, stats_hash|
      if consolidated[item_key]
        consolidated[item_key][:count]+=1
      else
        consolidated[item_key]=stats_hash
        consolidated[item_key][:count]=1
      end
    end
  end
  consolidated
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    name= coupon[:item]
    if cart[name] && cart[name][:count]>=coupon[:num]
      if cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"][:count]+=1
      else
        cart["#{name} W/COUPON"]= {:price=>coupon[:cost],:clearance=>cart[name][:clearance],:count=>1}
      end
      cart[name][:count]-=coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item,stats_hash|
    if stats_hash[:clearance]==true
      stats_hash[:price]=stats_hash[:price]-(stats_hash[:price]*0.2)
    end
  end
end

def checkout(cart, coupons)
  total_cost=0
  cart= consolidate_cart(cart)
  cart= apply_coupons(cart, coupons)
  cart= apply_clearance(cart)
  cart.each do |food, food_hash|
    if food_hash[:count]>0
      total_cost+=food_hash[:price]*food_hash[:count]
    end
  end
  if total_cost>100
    total_cost=total_cost-(total_cost*0.1)
  end
  total_cost
end
