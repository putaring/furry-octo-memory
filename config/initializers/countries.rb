module ISO3166
  class Country
    def self.with_indian_population
      country_alpha2_codes = %w(AR AU BH BD CA CO FJ FR GY IN ID IE IL IT KE KW LS MY MU MM NP NL NZ OM PK PT QA RE SA SG ZA LK SR TZ TH TT AE GB US YE)
      all.select { |country, _| country.alpha2.in?(country_alpha2_codes)}.sort_by(&:name)
    end
  end
end
