require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  let(:valid_attributes) {
    {
      title: 'Test Task',
      description: 'Test Description',
      status: 'not_started',
      priority: '2',
      due_date: Date.current + 7.days
    }
  }

  let(:invalid_attributes) {
    {
      title: '',
      status: 'invalid',
      priority: 'invalid'
    }
  }

  describe "GET /tasks" do
    it "returns a success response" do
      get tasks_path
      expect(response).to be_successful
    end

    it "displays all tasks" do
      task = Task.create! valid_attributes
      get tasks_path
      expect(response.body).to include(task.title)
    end
  end

  describe "GET /tasks/:id" do
    it "returns a success response" do
      task = Task.create! valid_attributes
      get task_path(task)
      expect(response).to be_successful
    end

    it "displays the requested task" do
      task = Task.create! valid_attributes
      get task_path(task)
      expect(response.body).to include(task.title)
      expect(response.body).to include(task.description)
    end
  end

  describe "GET /tasks/new" do
    it "returns a success response" do
      get new_task_path
      expect(response).to be_successful
    end

    it "displays the new task form" do
      get new_task_path
      expect(response.body).to include('New task')
    end
  end

  describe "GET /tasks/:id/edit" do
    it "returns a success response" do
      task = Task.create! valid_attributes
      get edit_task_path(task)
      expect(response).to be_successful
    end

    it "displays the edit form with task data" do
      task = Task.create! valid_attributes
      get edit_task_path(task)
      expect(response.body).to include(task.title)
    end
  end

  describe "POST /tasks" do
    context "with valid params" do
      it "creates a new Task" do
        expect {
          post tasks_path, params: { task: valid_attributes }
        }.to change(Task, :count).by(1)
      end

      it "redirects to the created task" do
        post tasks_path, params: { task: valid_attributes }
        expect(response).to redirect_to(Task.last)
      end

      it "sets a success notice" do
        post tasks_path, params: { task: valid_attributes }
        follow_redirect!
        expect(response.body).to include("Task was successfully created.")
      end
    end

    context "with invalid params" do
      it "does not create a new Task" do
        expect {
          post tasks_path, params: { task: invalid_attributes }
        }.to change(Task, :count).by(0)
      end

      it "returns a unprocessable entity response" do
        post tasks_path, params: { task: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "renders the new template" do
        post tasks_path, params: { task: invalid_attributes }
        expect(response.body).to include('New task')
      end
    end

    context "with JSON format" do
      it "creates a new Task and returns created status" do
        post tasks_path, params: { task: valid_attributes }, headers: { 'Accept': 'application/json' }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end

      it "returns unprocessable entity status for invalid params" do
        post tasks_path, params: { task: invalid_attributes }, headers: { 'Accept': 'application/json' }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PUT /tasks/:id" do
    context "with valid params" do
      let(:new_attributes) {
        {
          title: 'Updated Task',
          status: 'completed'
        }
      }

      it "updates the requested task" do
        task = Task.create! valid_attributes
        put task_path(task), params: { task: new_attributes }
        task.reload
        expect(task.title).to eq('Updated Task')
        expect(task.status).to eq('completed')
      end

      it "redirects to the task" do
        task = Task.create! valid_attributes
        put task_path(task), params: { task: valid_attributes }
        expect(response).to redirect_to(task)
      end

      it "sets a success notice" do
        task = Task.create! valid_attributes
        put task_path(task), params: { task: valid_attributes }
        follow_redirect!
        expect(response.body).to include("Task was successfully updated.")
      end
    end

    context "with invalid params" do
      it "does not update the task" do
        task = Task.create! valid_attributes
        original_title = task.title
        put task_path(task), params: { task: invalid_attributes }
        task.reload
        expect(task.title).to eq(original_title)
      end

      it "returns a unprocessable entity response" do
        task = Task.create! valid_attributes
        put task_path(task), params: { task: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "renders the edit template" do
        task = Task.create! valid_attributes
        put task_path(task), params: { task: invalid_attributes }
        expect(response.body).to include('Editing task')
      end
    end

    context "with JSON format" do
      it "updates the task and returns ok status" do
        task = Task.create! valid_attributes
        put task_path(task), params: { task: valid_attributes }, headers: { 'Accept': 'application/json' }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end

      it "returns unprocessable entity status for invalid params" do
        task = Task.create! valid_attributes
        put task_path(task), params: { task: invalid_attributes }, headers: { 'Accept': 'application/json' }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /tasks/:id" do
    it "destroys the requested task" do
      task = Task.create! valid_attributes
      expect {
        delete task_path(task)
      }.to change(Task, :count).by(-1)
    end

    it "redirects to the tasks list" do
      task = Task.create! valid_attributes
      delete task_path(task)
      expect(response).to redirect_to(tasks_url)
    end

    it "sets a success notice" do
      task = Task.create! valid_attributes
      delete task_path(task)
      follow_redirect!
      expect(response.body).to include("Task was successfully destroyed.")
    end

    context "with JSON format" do
      it "returns no content status" do
        task = Task.create! valid_attributes
        delete task_path(task), headers: { 'Accept': 'application/json' }
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end