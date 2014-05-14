require 'spec_helper'

feature "Challenges page filter" do

  let!(:active_ch) { FactoryGirl.create(:challenge) }
  let!(:working_on_ch) { FactoryGirl.create(:challenge, status: 'working_on') }
  let!(:finished_ch) { FactoryGirl.create(:challenge, status: 'finished') }
  let!(:cancelled_ch) { FactoryGirl.create(:challenge, status: 'cancelled') }

  before do
    double(Challenge.paginates_per(2))
    visit challenges_path
  end

  scenario "Default filter is by date" do
    # Default aquila behavior
    pending
    page.should have_content(cancelled_ch.title)
    page.should_not have_content(active_ch.title)
  end

  scenario "Active filter shows only active challenges" do
    # Default aquila behavior
    pending
    click_link("Activos")
    page.should have_content(active_ch.title)
    page.should_not have_content(finished_ch.title)
  end

  scenario "Inactive filter shows only the finished challenges" do
    # Default aquila behavior
    pending
    click_link("Concluidos")
    page.should have_content(finished_ch.title)
    page.should_not have_content(active_ch.title)
  end

  scenario "Most popular filter challenges sorted by most collaborators" do
    # Default aquila behavior
    pending
    FactoryGirl.create_list(:collaboration, 3, challenge: finished_ch)
    FactoryGirl.create_list(:collaboration, 1, challenge: active_ch)
    click_link("Más populares")
    page.should have_content(finished_ch.title)
    page.should_not have_content(working_on_ch.title)
  end

  scenario "Most recent orders challenges by date" do
    # Default aquila behavior
    pending
    click_link("Más recientes")
    page.should have_content(cancelled_ch.title)
    page.should_not have_content(active_ch.title)
  end
end