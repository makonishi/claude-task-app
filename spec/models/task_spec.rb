require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it 'validates presence of title' do
      task = Task.new(title: nil, status: 'not_started', priority: '2')
      expect(task).not_to be_valid
      expect(task.errors[:title]).to include("can't be blank")
    end
    
    it 'validates length of title' do
      task = Task.new(title: 'a' * 256, status: 'not_started', priority: '2')
      expect(task).not_to be_valid
      expect(task.errors[:title]).to include("is too long (maximum is 255 characters)")
    end
    
    it 'validates presence of status' do
      task = Task.new(title: 'Test', status: nil, priority: '2')
      expect(task).not_to be_valid
      expect(task.errors[:status]).to include("can't be blank")
    end
    
    it 'validates inclusion of status' do
      task = Task.new(title: 'Test', status: 'invalid', priority: '2')
      expect(task).not_to be_valid
      expect(task.errors[:status]).to include("is not included in the list")
    end
    
    it 'validates presence of priority' do
      task = Task.new(title: 'Test', status: 'not_started', priority: nil)
      expect(task).not_to be_valid
      expect(task.errors[:priority]).to include("can't be blank")
    end
    
    it 'validates inclusion of priority' do
      task = Task.new(title: 'Test', status: 'not_started', priority: '5')
      expect(task).not_to be_valid
      expect(task.errors[:priority]).to include("is not included in the list")
    end
  end
  
  describe 'scopes' do
    describe '.by_priority' do
      let!(:high_task) { create(:task, priority: '3') }
      let!(:medium_task) { create(:task, priority: '2') }
      let!(:low_task) { create(:task, priority: '1') }
      
      it 'orders tasks by priority: high (3), medium (2), low (1)' do
        ordered_tasks = Task.by_priority
        expect(ordered_tasks.first).to eq(high_task)
        expect(ordered_tasks.second).to eq(medium_task)
        expect(ordered_tasks.third).to eq(low_task)
      end
    end
    
    describe '.by_status' do
      let!(:not_started_task) { create(:task, status: 'not_started') }
      let!(:in_progress_task) { create(:task, status: 'in_progress') }
      let!(:completed_task) { create(:task, status: 'completed') }
      
      it 'filters tasks by status' do
        expect(Task.by_status('not_started')).to contain_exactly(not_started_task)
        expect(Task.by_status('in_progress')).to contain_exactly(in_progress_task)
        expect(Task.by_status('completed')).to contain_exactly(completed_task)
      end
    end
  end
  
  describe '#overdue?' do
    context 'when due_date is nil' do
      let(:task) { build(:task, due_date: nil) }
      
      it 'returns false' do
        expect(task.overdue?).to be false
      end
    end
    
    context 'when due_date is in the past' do
      let(:task) { build(:task, due_date: Date.current - 1.day) }
      
      it 'returns true' do
        expect(task.overdue?).to be true
      end
    end
    
    context 'when due_date is today' do
      let(:task) { build(:task, due_date: Date.current) }
      
      it 'returns false' do
        expect(task.overdue?).to be false
      end
    end
    
    context 'when due_date is in the future' do
      let(:task) { build(:task, due_date: Date.current + 1.day) }
      
      it 'returns false' do
        expect(task.overdue?).to be false
      end
    end
  end
  
  describe '#due_soon?' do
    context 'when due_date is nil' do
      let(:task) { build(:task, due_date: nil) }
      
      it 'returns false' do
        expect(task.due_soon?).to be false
      end
    end
    
    context 'when due_date is in the past' do
      let(:task) { build(:task, due_date: Date.current - 1.day) }
      
      it 'returns false' do
        expect(task.due_soon?).to be false
      end
    end
    
    context 'when due_date is today' do
      let(:task) { build(:task, due_date: Date.current) }
      
      it 'returns true' do
        expect(task.due_soon?).to be true
      end
    end
    
    context 'when due_date is within 3 days' do
      let(:task) { build(:task, due_date: Date.current + 2.days) }
      
      it 'returns true' do
        expect(task.due_soon?).to be true
      end
    end
    
    context 'when due_date is more than 3 days away' do
      let(:task) { build(:task, due_date: Date.current + 4.days) }
      
      it 'returns false' do
        expect(task.due_soon?).to be false
      end
    end
  end
end