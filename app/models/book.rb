class Book < ApplicationRecord
  validates_presence_of :title

  belongs_to :author
end
