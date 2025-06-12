class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :status, presence: true, inclusion: { in: %w[not_started in_progress completed on_hold] }
  validates :priority, presence: true, inclusion: { in: %w[1 2 3 4] }
  
  scope :by_priority, -> { order(Arel.sql("CAST(priority AS INTEGER) DESC")) }
  scope :by_status, ->(status) { where(status: status) }
  
  def overdue?
    due_date.present? && due_date < Date.current
  end
  
  def due_soon?
    due_date.present? && due_date <= Date.current + 3.days && due_date >= Date.current
  end
end
