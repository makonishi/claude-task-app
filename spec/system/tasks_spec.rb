require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "タスク一覧画面" do
    context "タスクが存在しない場合" do
      it "空のメッセージが表示される" do
        # Ensure no tasks exist
        Task.destroy_all
        
        visit tasks_path
        expect(page).to have_content("No tasks")
        expect(page).to have_content("Get started by creating a new task.")
        expect(page).to have_link("New Task")
      end
    end

    context "タスクが存在する場合" do
      let!(:task1) { create(:task, title: "高優先度タスク", priority: '3', status: "not_started") }
      let!(:task2) { create(:task, title: "中優先度タスク", priority: '2', status: "in_progress") }
      let!(:task3) { create(:task, title: "低優先度タスク", priority: '1', status: "completed") }

      it "すべてのタスクが表示される" do
        visit tasks_path
        expect(page).to have_content("高優先度タスク")
        expect(page).to have_content("中優先度タスク")
        expect(page).to have_content("低優先度タスク")
      end

      it "タスクの詳細情報が表示される" do
        visit tasks_path
        
        # タスクが表示されているか確認
        expect(page).to have_content(task1.title)
        
        # 最初のタスクカード内で詳細を確認
        within first(".bg-white.overflow-hidden.shadow") do
          expect(page).to have_content(task1.title)
          expect(page).to have_content("not_started")
          expect(page).to have_content("3")
        end
      end

      it "タスクをクリックすると詳細画面に遷移する" do
        visit tasks_path
        click_link task1.title
        expect(current_path).to eq(task_path(task1))
      end
    end
  end

  describe "タスク作成" do
    it "有効な情報でタスクを作成できる" do
      visit new_task_path
      
      fill_in "Title", with: "新しいタスク"
      fill_in "Description", with: "タスクの説明"
      select "Not Started", from: "Status"
      select "High", from: "Priority"
      fill_in "Due date", with: Date.current + 7.days
      
      click_button "Create Task"
      
      expect(page).to have_content("Task was successfully created")
      expect(page).to have_content("新しいタスク")
      expect(page).to have_content("タスクの説明")
    end

    it "無効な情報ではタスクを作成できない" do
      visit new_task_path
      
      # タイトルを空にする
      fill_in "Title", with: ""
      select "Not Started", from: "Status"
      select "Medium", from: "Priority"
      
      click_button "Create Task"
      
      expect(page).to have_content("Title can't be blank")
      expect(current_path).to eq(tasks_path)
    end
  end

  describe "タスク編集" do
    let!(:task) { create(:task, title: "元のタイトル") }

    it "タスクを更新できる" do
      visit edit_task_path(task)
      
      fill_in "Title", with: "更新されたタイトル"
      select "Completed", from: "Status"
      
      click_button "Update Task"
      
      expect(page).to have_content("Task was successfully updated")
      expect(page).to have_content("更新されたタイトル")
      expect(page).to have_content("Completed")
    end

    it "無効な情報では更新できない" do
      visit edit_task_path(task)
      
      fill_in "Title", with: ""
      
      click_button "Update Task"
      
      expect(page).to have_content("Title can't be blank")
    end
  end

  describe "タスク削除" do
    let!(:task) { create(:task, title: "削除するタスク") }

    it "タスクを削除できる" do
      visit task_path(task)
      
      # rack_testドライバーではJavaScriptの確認ダイアログがサポートされていないため
      # data-turbo-confirm属性を無視して直接削除を実行
      click_button "Delete task"
      
      expect(page).to have_content("Task was successfully destroyed")
      expect(current_path).to eq(tasks_path)
      expect(page).not_to have_content("削除するタスク")
    end
  end

  describe "ナビゲーション" do
    let!(:task) { create(:task) }

    it "ヘッダーのリンクが正しく機能する" do
      visit root_path
      
      # "All Tasks"リンク
      click_link "All Tasks"
      expect(current_path).to eq(tasks_path)
      
      # "New Task"リンク - ヘッダー内のリンクを指定
      within('nav') do
        click_link "New Task"
      end
      expect(current_path).to eq(new_task_path)
    end

    it "詳細画面から一覧画面に戻れる" do
      visit task_path(task)
      click_link "Back to tasks"
      expect(current_path).to eq(tasks_path)
    end
  end
end