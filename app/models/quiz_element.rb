class QuizElement < Element
  scope :saves, -> { where(name: "Save") }
end