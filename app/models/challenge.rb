#encoding: utf-8
class Challenge < ActiveRecord::Base

  attr_accessible :dataset_url, :description, :owner_id, :status, :title, :additional_links,
                  :first_spec, :second_spec, :third_spec, :pitch, :avatar, :about, :activities_attributes, :dataset_file

  attr_accessor :dataset_file

  mount_uploader :avatar, ChallengeAvatarUploader

  # Relations
	has_many :collaborations
	has_many :collaborators, through: :collaborations, class_name: "Member", source: :member
  has_many :activities

	belongs_to :creator, class_name: "User"
  belongs_to :organization
	# Validations
	validates :description, :title, :status, :about, :pitch, presence: true
	validates :pitch, length: { maximum: 140 }

  accepts_nested_attributes_for :activities, :reject_if => lambda { |a| a[:text].blank? }

  before_create :upload_file
  after_create :create_initial_activity

  #Scopes
  scope :in_zapopan, lambda {
    where("id IN (?)", (24..41).to_a) 
  }
	# Additionals
	acts_as_voteable
	acts_as_commentable

  scope :recents, lambda { |limit| order('created_at DESC').limit(limit) } 

  # Embeddables
  auto_html_for :description do
    simple_format
    image
    youtube width: 400, height: 250, wmode: "transparent"
    vimeo   width: 400, height: 250
    link target: "_blank", rel: "nofollow"
  end

	STATUS = [:open, :working_on, :cancelled, :finished]

	def cancel!
		self.status = :cancelled
		self.save
	end

	def update_likes_counter
    self.likes_counter = self.votes_count
    self.save
  end

  def total_references
    self.references.size
  end

  def references
    (self.additional_links || '').split(",")
  end

  def about
    self[:about].to_s
  end

  def timeline_json
    {
      "timeline" =>
      {
        "headline" => "Actividades y Noticias",
        "type" => "default",
        "startDate" => self.created_at.year,
        "text" => "",
        "date" => self.activities.map do |activity|
          date = activity.created_at.strftime("%Y, %m, %d")
          {
            "startDate" => date,
            "endDate" => date,
            "headline" => activity.title,
            "text" => activity.text,
            "asset" =>
            {
              "media" => "",
              "credit" => "",
              "caption" => ""
            }
          }

        end
      }
    }    
  end

  private

  def create_initial_activity
    self.activities.create(title: I18n.t("challenges.initial_activity.title"), text: I18n.t("challenges.initial_activity.text"))
  end

  def upload_file
    return true if @dataset_file.blank?

    dataset_name = self.title.gsub(/\s/,'_').downcase

    # Upload dataset resource
    resource = CKAN::Resource.new(name: @dataset_file.original_filename, title: self.title)
    resource.content = File.read(@dataset_file.tempfile)
    resource.upload(CKAN_API_KEY)

    # Create dataset
    datastore = CKAN::Datastore.new(name: dataset_name, title: @title)
    datastore.resources = [resource]
    response = datastore.upload(CKAN_API_KEY)
    created = JSON.parse(response.body)
    self.dataset_url = created['ckan_url']
  end

end
