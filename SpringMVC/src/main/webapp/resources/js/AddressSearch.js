// 카카오 지도 API의 장소 검색 서비스 객체를 생성
var ps = new kakao.maps.services.Places();

// 장소 검색 함수
function searchPlace() {
    var keyword = document.getElementById('location').value;  // 입력된 키워드 (장소)
    
    if (!keyword) {
        alert("장소를 입력해 주세요.");
        return;
    }

    // 장소 검색 요청
    ps.keywordSearch(keyword, placesSearchCB); // 검색 결과를 처리하는 콜백 함수
}

// 장소 검색 결과 콜백 함수
function placesSearchCB(data, status, pagination) {
    var placeList = document.getElementById('placeList');
    placeList.innerHTML = ''; // 이전 검색 결과 지우기
    
    if (status === kakao.maps.services.Status.OK) {
        // 검색된 장소 목록
        var resultList = data.map(function(place) {
            return {
                name: place.place_name,  // 장소 이름
                address: place.address_name  // 주소
            };
        });

        // 장소 리스트를 사용자에게 보여주기
        if (resultList.length === 0) {
            placeList.innerHTML = '<li>검색 결과가 없습니다.</li>';
        } else {
            resultList.forEach(function(place) {
                var li = document.createElement('li');
                li.textContent = place.name;
                li.onclick = function() {
                    document.getElementById('location').value = place.name;  // 장소 선택 시 입력란에 값 채우기
                    document.getElementById('detailedAddress').textContent = place.address;  // 주소 상세 정보 표시
                    placeList.innerHTML = '';  // 목록 지우기
                };
                placeList.appendChild(li);
            });
        }
    } else {
        placeList.innerHTML = '<li>장소 검색에 실패했습니다. 다시 시도해 주세요.</li>';
    }
}