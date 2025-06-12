require 'rails_helper'

RSpec.describe TasksController, type: :controller do
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

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns all tasks as @tasks" do
      task = Task.create! valid_attributes
      get :index
      expect(assigns(:tasks)).to include(task)
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      task = Task.create! valid_attributes
      get :show, params: {id: task.to_param}
      expect(response).to be_successful
    end

    it "assigns the requested task as @task" do
      task = Task.create! valid_attributes
      get :show, params: {id: task.to_param}
      expect(assigns(:task)).to eq(task)
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end

    it "assigns a new task as @task" do
      get :new
      expect(assigns(:task)).to be_a_new(Task)
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      task = Task.create! valid_attributes
      get :edit, params: {id: task.to_param}
      expect(response).to be_successful
    end

    it "assigns the requested task as @task" do
      task = Task.create! valid_attributes
      get :edit, params: {id: task.to_param}
      expect(assigns(:task)).to eq(task)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Task" do
        expect {
          post :create, params: {task: valid_attributes}
        }.to change(Task, :count).by(1)
      end

      it "redirects to the created task" do
        post :create, params: {task: valid_attributes}
        expect(response).to redirect_to(Task.last)
      end

      it "sets a success notice" do
        post :create, params: {task: valid_attributes}
        expect(flash[:notice]).to eq("Task was successfully created.")
      end
    end

    context "with invalid params" do
      it "does not create a new Task" do
        expect {
          post :create, params: {task: invalid_attributes}
        }.to change(Task, :count).by(0)
      end

      it "returns a unprocessable entity response" do
        post :create, params: {task: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "renders the new template" do
        post :create, params: {task: invalid_attributes}
        expect(response).to render_template("new")
      end
    end

    context "with JSON format" do
      it "creates a new Task and returns created status" do
        post :create, params: {task: valid_attributes, format: :json}
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end

      it "returns unprocessable entity status for invalid params" do
        post :create, params: {task: invalid_attributes, format: :json}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {
          title: 'Updated Task',
          status: 'completed'
        }
      }

      it "updates the requested task" do
        task = Task.create! valid_attributes
        put :update, params: {id: task.to_param, task: new_attributes}
        task.reload
        expect(task.title).to eq('Updated Task')
        expect(task.status).to eq('completed')
      end

      it "redirects to the task" do
        task = Task.create! valid_attributes
        put :update, params: {id: task.to_param, task: valid_attributes}
        expect(response).to redirect_to(task)
      end

      it "sets a success notice" do
        task = Task.create! valid_attributes
        put :update, params: {id: task.to_param, task: valid_attributes}
        expect(flash[:notice]).to eq("Task was successfully updated.")
      end
    end

    context "with invalid params" do
      it "does not update the task" do
        task = Task.create! valid_attributes
        original_title = task.title
        put :update, params: {id: task.to_param, task: invalid_attributes}
        task.reload
        expect(task.title).to eq(original_title)
      end

      it "returns a unprocessable entity response" do
        task = Task.create! valid_attributes
        put :update, params: {id: task.to_param, task: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "renders the edit template" do
        task = Task.create! valid_attributes
        put :update, params: {id: task.to_param, task: invalid_attributes}
        expect(response).to render_template("edit")
      end
    end

    context "with JSON format" do
      it "updates the task and returns ok status" do
        task = Task.create! valid_attributes
        put :update, params: {id: task.to_param, task: valid_attributes, format: :json}
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end

      it "returns unprocessable entity status for invalid params" do
        task = Task.create! valid_attributes
        put :update, params: {id: task.to_param, task: invalid_attributes, format: :json}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested task" do
      task = Task.create! valid_attributes
      expect {
        delete :destroy, params: {id: task.to_param}
      }.to change(Task, :count).by(-1)
    end

    it "redirects to the tasks list" do
      task = Task.create! valid_attributes
      delete :destroy, params: {id: task.to_param}
      expect(response).to redirect_to(tasks_url)
    end

    it "sets a success notice" do
      task = Task.create! valid_attributes
      delete :destroy, params: {id: task.to_param}
      expect(flash[:notice]).to eq("Task was successfully destroyed.")
    end

    context "with JSON format" do
      it "returns no content status" do
        task = Task.create! valid_attributes
        delete :destroy, params: {id: task.to_param, format: :json}
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end