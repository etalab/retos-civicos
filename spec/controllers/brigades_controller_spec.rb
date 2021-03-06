require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe BrigadesController do

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # BrigadesController. Be sure to keep this updated too.
  let(:valid_session) { {} }
  include_context 'user logged in', {
      'location_id' => '1',
      'description' => 'Bienvenido a la brigada de Monterrey! Come with us.',
      'calendar_url' => 'https://www.google.com/calendar/ical/odyssey.charter%40odyssey.k12.de.us/public/basic.ics',
      'slack_url' => 'https://codeandomexico.slack.com/messages/general',
      'github_url' => 'https://github.com/CodeandoMexico',
      'facebook_url' => 'https://www.facebook.com/CodeandoMexico',
      'twitter_url' => 'https://twitter.com/codeandomexico',
      'header_image_url' => 'http://www.dronestagr.am/wp-content/uploads/2014/10/cerrosilla.png'
  }

  describe 'GET index' do
    it 'assigns all brigades as @brigades' do
      brigade = Brigade.create! @valid_attributes_with_user
      get :index, 'locale' => 'en'
      assigns(:brigades).should eq([brigade])
    end
  end

  describe 'GET show' do
    it 'assigns the requested brigade as @brigade' do
      brigade = Brigade.create! @valid_attributes_with_user
      get :show, :id => brigade.to_param, 'locale' => 'en'
      assigns(:brigade).should eq(brigade)
    end
  end

  describe 'GET new' do
    it 'assigns a new brigade as @brigade' do
      get :new, 'locale' => 'en'
      assigns(:brigade).should be_a_new(Brigade)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested brigade as @brigade' do
      brigade = Brigade.create! @valid_attributes_with_user
      get :edit, :id => brigade.to_param, 'locale' => 'en'
      assigns(:brigade).should eq(brigade)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Brigade' do
        expect do
          post :create, 'brigade' => @valid_attributes_with_user, 'locale' => 'en'
        end.to change(Brigade, :count).by(1)
      end

      it 'assigns a newly created brigade as @brigade' do
        post :create, :brigade => @valid_attributes_with_user, 'locale' => 'en'
        assigns(:brigade).should be_a(Brigade)
        assigns(:brigade).should be_persisted
      end

      it 'redirects to the created brigade' do
        post :create, :brigade => @valid_attributes_with_user, 'locale' => 'en'
        response.should redirect_to(Brigade.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved brigade as @brigade' do
        # Trigger the behavior that occurs when invalid params are submitted
        Brigade.any_instance.stub(:save).and_return(false)
        post :create, :brigade => { 'location_id' => 'invalid value' }, 'locale' => 'en'
        assigns(:brigade).should be_a_new(Brigade)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Brigade.any_instance.stub(:save).and_return(false)
        post :create, :brigade => { 'location_id' => 'invalid value' }, 'locale' => 'en'
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested brigade' do
        brigade = Brigade.create! @valid_attributes_with_user
        # Assuming there are no other brigades in the database, this
        # specifies that the Brigade created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Brigade.any_instance.should_receive(:update_attributes).with(hash_including(location_id: 'MyString'))
        put :update, :id => brigade.to_param, :brigade => { 'location_id' => 'MyString' }, 'locale' => 'en'
      end

      it 'assigns the requested brigade as @brigade' do
        brigade = Brigade.create! @valid_attributes_with_user
        put :update, :id => brigade.to_param, :brigade => @valid_attributes_with_user, 'locale' => 'en'
        assigns(:brigade).should eq(brigade)
      end

      it 'redirects to the brigade' do
        brigade = Brigade.create! @valid_attributes_with_user
        put :update, :id => brigade.to_param, :brigade => @valid_attributes_with_user, 'locale' => 'en'
        response.should redirect_to(brigade)
      end
    end

    describe 'with invalid params' do
      it 'assigns the brigade as @brigade' do
        brigade = Brigade.create! @valid_attributes_with_user
        # Trigger the behavior that occurs when invalid params are submitted
        Brigade.any_instance.stub(:save).and_return(false)
        put :update, :id => brigade.to_param, :brigade => { 'location_id' => 'invalid value' }, 'locale' => 'en'
        assigns(:brigade).should eq(brigade)
      end

      it "re-renders the 'edit' template" do
        brigade = Brigade.create! @valid_attributes_with_user
        # Trigger the behavior that occurs when invalid params are submitted
        Brigade.any_instance.stub(:save).and_return(false)
        put :update, :id => brigade.to_param, :brigade => { 'location_id' => 'invalid value' }, 'locale' => 'en'
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested brigade' do
      brigade = Brigade.create! @valid_attributes_with_user
      expect do
        delete :destroy, :id => brigade.to_param, 'locale' => 'en'
      end.to change(Brigade, :count).by(-1)
    end

    it 'redirects to the brigades list' do
      brigade = Brigade.create! @valid_attributes_with_user
      delete :destroy, :id => brigade.to_param, 'locale' => 'en'
      response.should redirect_to(brigades_url)
    end
  end
end
