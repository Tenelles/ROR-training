# frozen_string_literal: true

class CargoVan < Van
  def type # public, как у родителя
    :cargo
  end
end
