import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['selectedRegionId', 'selectProvinceId', 'selectCityMunicipalityId', 'selectBarangayId']

  fetchProvinces() {
    let target = this.selectProvinceIdTarget
    $(target).empty();
    $.ajax({
      type: 'GET',
      url: '/api/regions/' + this.selectedRegionIdTarget.value + '/provinces',
      dataType: 'json',
      success: (response) => {
        console.log(response)
        let option = document.createElement('option')
        option.value = ''
        option.text = 'Please select Province'
        target.appendChild(option)
        $.each(response, function (index, record) {
          let option = document.createElement('option')
          option.value = record.id
          option.text = record.name
          target.appendChild(option)
        })
      }
    })
  }

  fetchCityMunicipality() {
    let target = this.selectCityMunicipalityIdTarget
    $(target).empty();
    $.ajax({
      type: 'GET',
      url: '/api/regions/' + this.selectedRegionIdTarget.value + '/provinces/' + this.selectProvinceIdTarget.value + '/city_municipalities/',
      dataType: 'json',
      success: (response) => {
        console.log(response)
        let option = document.createElement('option')
        option.value = ''
        option.text = 'Please select City/Municipality'
        target.appendChild(option)
        $.each(response, function (index, record) {
          let option = document.createElement('option')
          option.value = record.id
          option.text = record.name
          target.appendChild(option)
        })
      }
    })
  }

  fetchBarangays() {
    let target = this.selectBarangayIdTarget
    $(target).empty();
    $.ajax({
      type: 'GET',
      // /get_barangays_by/:municipality_id/
      url: '/api/regions/' + this.selectedRegionIdTarget.value + '/provinces/' + this.selectProvinceIdTarget.value + '/city_municipalities/' + this.selectCityMunicipalityIdTarget.value + '/barangays',
      dataType: 'json',
      success: (response) => {
        console.log(response)
        let option = document.createElement('option')
        option.value = ''
        option.text = 'Please select Barangay'
        target.appendChild(option)
        $.each(response, function (index, record) {
          let option = document.createElement('option')
          option.value = record.id
          option.text = record.name
          target.appendChild(option)
        })
      }
    })
  }
}
