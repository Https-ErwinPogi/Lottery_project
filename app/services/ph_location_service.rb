class PhLocationService
  attr_reader :url

  def initialize
    @url = 'https://psgc.gitlab.io/api'
  end

  def fetch_region
    request = RestClient.get("#{url}/regions")
    data = JSON.parse(request.body)
    data.each do |region|
      address_region = Address::Region.find_or_initialize_by(code: region['code'])
      address_region.name = region['regionName']
      address_region.save
    end
  end

  def fetch_province
    request = RestClient.get("#{url}/provinces")
    provinces = JSON.parse(request.body)
    provinces.each do |province|
      region = Address::Region.find_by_code(province['regionCode'])
      Address::Province.find_or_create_by(code: province['code'], name: province['name'], region: region)
    end
    request = RestClient.get("#{url}/districts")
    districts = JSON.parse(request.body)
    districts.each do |district|
      region = Address::Region.find_by_code(district['regionCode'])
      Address::Province.find_or_create_by(code: district['code'], name: district['name'], region: region)
    end
  end

  def fetch_city_municipality
    request = RestClient.get("#{url}/cities-municipalities")
    data = JSON.parse(request.body)
    data.each do |city_municipality|
      if city_municipality['provinceCode']
        province = Address::Province.find_by_code(city_municipality['provinceCode'])
        Address::CityMunicipality.find_or_create_by(code: city_municipality['code'], name: city_municipality['name'], province: province)
      elsif city_municipality['districtCode']
        province = Address::Province.find_by_code(city_municipality['districtCode'])
        Address::CityMunicipality.find_or_create_by(code: city_municipality['code'], name: city_municipality['name'], province: province)
      else
        if city_municipality['name'] == "City of Isabela"
          province = Address::Province.find_by_name('Basilan')
          Address::CityMunicipality.find_or_create_by(code: city_municipality['code'], name: city_municipality['name'], province: province)
        elsif city_municipality['name'] == "City of Cotabato"
          province = Address::Province.find_by_name('Maguindanao')
          Address::CityMunicipality.find_or_create_by(code: city_municipality['code'], name: city_municipality['name'], province: province)
        end
      end
    end
  end

  def fetch_barangay
    request = RestClient.get("#{url}/barangays")
    data = JSON.parse(request.body)
    data.each do |barangay|
      if barangay['cityCode']
        address_city_municipality = Address::CityMunicipality.find_by_code(barangay['cityCode'])
        address_barangay = Address::Barangay.find_or_initialize_by(code: barangay['code'])
        address_barangay.name = barangay['name']
        address_barangay.city_municipality = address_city_municipality
        address_barangay.save
      else
        address_city_municipality = Address::CityMunicipality.find_by_code(barangay['municipalityCode'])
        address_barangay = Address::Barangay.find_or_initialize_by(code: barangay['code'])
        address_barangay.name = barangay['name']
        address_barangay.city_municipality = address_city_municipality
        address_barangay.save
      end
    end
  end
end