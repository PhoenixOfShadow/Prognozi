class Match < ActiveRecord::Base
  just_define_datetime_picker :start_at, add_to_attr_accessible: true
  validates :start_at, presence: true

  attr_accessible :guest_id, :guest_score, :host_id, :host_score, :sign,
                  :phase_type, :phase_id, :code, :location

  attr_accessor :name, :result

  belongs_to :host, class_name: 'Team'
  belongs_to :guest, class_name: 'Team'
  belongs_to :phase, polymorphic: true

  has_many :match_predictions

  after_save :calculate_prediction_points

  def name
    "#{host.try(:name)} - #{guest.try(:name)}"
  end

  def result
    "#{host_score}:#{guest_score}"
  end

  private
    def calculate_prediction_points
      if guest_score_changed? or host_score_changed?
        if self.host_score.present? and self.guest_score.present?
          ssign = 'X'
          if  host_score > guest_score
            ssign = '1'
          elsif host_score < guest_score
            ssign = '2'
          end
          self.update_column(:sign, ssign)

          self.match_predictions.each do |prediction|
            points = 0

            #Check for score predicition
            if(self.host_score == prediction.host_score and self.guest_score == prediction.guest_score)
              points += $point_rules.m_score_points
              # prediction.points += rules.exact_result
            end

            #Check for sign prediction
            if(self.sign == prediction.sign)
              points += $point_rules.m_sign_points
            end

            pp = PredictionPoint.find_or_initialize_by_user_id_and_prediction_type_and_prediction_id(prediction.user_id, 'MatchPrediction', prediction.id)
            pp.points = points
            pp.save
          end
        else
          self.update_column(:sign, nil)
          self.match_predictions.each do |prediction|
            PredictionPoint.destroy_all(prediction_type: 'MatchPrediction', prediction_id: prediction.id)
          end
        end
      end
    end
end
