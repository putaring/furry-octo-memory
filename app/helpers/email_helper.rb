module EmailHelper
  def transactional_campaign(name)
    {
      utm_source: :transactional,
      utm_medium: :email,
      utm_campaign: name
    }
  end
end
