class Subject < ActiveRecord::Base
	has_and_belongs_to_many :users

	def self.search(keyword)
		query = ''
		for c in keyword.split(//u) do query << '%' + c end
		query << '%'
		if keyword
			where('subject_name LIKE ?', query)
		else
			all
		end
	end
end
