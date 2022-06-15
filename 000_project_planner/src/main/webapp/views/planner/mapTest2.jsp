<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/style.css"/>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/mapStyle.css"/>

<!-- 지도 -->
	    	
<!-- 	<div class="container2">
		<button id="searchBox" class="z1" onclick="SearchBox();" width="30">search</button>
	</div> -->
	<div class="searchContainer">		
	</div>
	
		
		
<div class="map_wrap">
    <div id="map"></div>

    <div id="menu_wrap" class="bg_white">
<!--     	<div id="searchbox"> -->
		        <div class="option">
		            <div>
		            	<h1 id="listTitle" style="text-align:left;padding:10px;margin-bottom:0px;margin-left:5px;">SEARCH</h1>
		                <form onsubmit="searchPlaces(); return false;" id="searchBox">
		                    	<input type="text" value="에버랜드" id="keyword" size="40" placeholder="검색어를 입력하세요"> 
		                    	<button id="searchBtn" type="submit">검색하기</button> 
		                </form>
		            </div>
		        </div>
		        <hr id="listLine">
		        <ul id="placesList"></ul>
		        <div id="pagination"></div>
<!--         </div>    -->        
    </div>
</div>
<button id="likesBtn" style="width:100px;">좋아요</button>
    

	<!-- 지도 관련 스크립트 -->
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a918dc059c0c7fe988d04540ed91f259&libraries=services"></script>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a918dc059c0c7fe988d04540ed91f259&libraries=LIBRARY"></script>
	
<script>

//const searchPlaces = document.getElementById("searchPlaces");



//마커를 담을 배열입니다
var markers = [];

var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = {
        center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };  

// 지도를 생성합니다    
var map = new kakao.maps.Map(mapContainer, mapOption); 

const likesBtn = document.getElementById("likesBtn");
map.addControl(likesBtn, kakao.maps.ControlPosition.LEFT);


 map.relayout();

// 장소 검색 객체를 생성합니다
var ps = new kakao.maps.services.Places();  

// 검색 결과 목록이나 마커를 클릭했을 때 장소명을 표출할 인포윈도우를 생성합니다
var infowindow = new kakao.maps.InfoWindow({zIndex:1});

// 키워드로 장소를 검색합니다
searchPlaces();

// 키워드 검색을 요청하는 함수입니다
function searchPlaces() {

    var keyword = document.getElementById('keyword').value;

    if (!keyword.replace(/^\s+|\s+$/g, '')) {
        alert('키워드를 입력해주세요!');
        return false;
    }

    // 장소검색 객체를 통해 키워드로 장소검색을 요청합니다
    ps.keywordSearch( keyword, placesSearchCB); 
}

// 장소검색이 완료됐을 때 호출되는 콜백함수 입니다
function placesSearchCB(data, status, pagination) {
    if (status === kakao.maps.services.Status.OK) {

        // 정상적으로 검색이 완료됐으면
        // 검색 목록과 마커를 표출합니다
        displayPlaces(data);

        // 페이지 번호를 표출합니다
        displayPagination(pagination);

    } else if (status === kakao.maps.services.Status.ZERO_RESULT) {

        alert('검색 결과가 존재하지 않습니다.');
        return;

    } else if (status === kakao.maps.services.Status.ERROR) {

        alert('검색 결과 중 오류가 발생했습니다.');
        return;

    }
}
//------------------------------------------------------------------------


//마커 위에 커스텀오버레이를 표시합니다
//마커를 중심으로 커스텀 오버레이를 표시하기위해 CSS를 이용해 위치를 설정했습니다

var customContent = '<div class="wrap">' + 
            '    	 <div class="info">' + 
            '        <div class="title">' + 
            '            여기 괜찮아요?' + 
            '            <div class="close" onclick="closeOverlay()" title="닫기"></div>' + 
            '        </div>' + 
            '        <div class="body">' + 
            '            <div class="desc">' + 
            '                <div class="ellipsis" style="margin-bottom:10px;font-size:50">장소를 플랜에 추가할까요?</div>' +
            				 '<input type="text" placeholder="메모를 작성해주세요">'+
    '               		 <button id="addBtn" onclick="addList();" class="addToList" style="font-size:12px;margin-left:20px;width:50px;">좋아요</button>' + 
            '        	 </div>' + 
            '    </div>' +    
            '</div>'+
            '<div style="display:none", id="hiddenLat"></div>' //마커의 위도
            +'<div style="display:none", id="hiddenLng"></div>' //마커의 경도
            +'<div style="display:none", id="hiddenTitle"></div>'; //마커의 장소명
 
function addList(){ //특정 장소를 사용자의 플랜 리스트에 추가하는 인터페이스
	clearDragEvent();
	       	
	const lat = document.getElementById("hiddenLat").innerText;
	const lng = document.getElementById("hiddenLng").innerText;
 	const placeTitle = document.getElementById("hiddenTitle").innerText;
 	
	console.log("위도 : ",lat,"경도, ",lng,"타이틀",placeTitle);

	//장소 카드 생성해, 플랜 리스트에 추가하기 -----------------------------------
	const dropZone = document.getElementById("dropZone");
	
	const addPlan = document.createElement("div"); //div생성하기
	addPlan.classList.add("box_drag");
	addPlan.setAttribute("draggable",true);
	addPlan.innerText = placeTitle;

	//index를 식별하기 위해, 현재 dropZone에 자식 태그들이 몇 개 있는지 확인하기	
	
	const cards = document.querySelectorAll("div#dropZone div");
	console.log("현재 카드 개수 : ",cards.length);
	let tempNo = cards.length+1;
	addPlan.id="p"+tempNo; //☆ addPlan > id값 다시 정해야 함...
	dropZone.insertAdjacentElement("beforeend",addPlan);
	addDragEvent();
	
	console.log(addPlan);
	
	choTest(addPlan);
} 



/* 	//장소카드 더블 클릭 시, 삭제되도록 로직 구현하기
	const removeCards = document.querySelectorAll("div#dropZone div");

	console.log("존재하긴 하냐고 : ",removeCards);
	
	removeCards.forEach(e=>{
	
		console.log("뭔데? : ",e);
		e.addEventListener("dblclick",e=>{
			alert("하이!");
		}); 
		choTest(e);
		console.log("등록 완료!");
	
	}); */
	
	
	//window.onload()함수로 등록하면 된다고 함...
    function choTest(e){
    	let dropZone = document.getElementById("dropZone");   	
    	e.addEventListener("dblclick",e=>{   		
    		alert("삭제!");
    		dropZone.removeChild(e.target);   		
    	});
    };
    
    (()=>{
    	
    	
    	alert("하이!")
    	//장소카드 더블 클릭 시, 삭제되도록 로직 구현하기☆ (기존 카드는 이벤트 등록이 안 되는데 왤까?)
    	const removeCards = document.querySelectorAll("div#dropZone div");

    	console.log("존재하긴 하냐고 : ",removeCards);
    	
    	removeCards.forEach(e=>{
    	
    		console.log("뭔데? : ",e);
    		e.addEventListener("dblclick",e=>{
    			alert("하이!");
    		}); 
    		choTest(e);
    		console.log("등록 완료!");
    	
    	});
    
      
    })();
    
            
//------------------------------------------------------------------------

// 검색 결과 목록과 마커를 표출하는 함수입니다
function displayPlaces(places) {

    var listEl = document.getElementById('placesList'), 
    menuEl = document.getElementById('menu_wrap'),
    fragment = document.createDocumentFragment(), 
    bounds = new kakao.maps.LatLngBounds(), 
    listStr = '';
    
    // 검색 결과 목록에 추가된 항목들을 제거합니다
    removeAllChildNods(listEl);

    // 지도에 표시되고 있는 마커를 제거합니다
    removeMarker();
    
    for ( var i=0; i<places.length; i++ ) {

        // 마커를 생성하고 지도에 표시합니다
        var placePosition = new kakao.maps.LatLng(places[i].y, places[i].x),
            marker = addMarker(placePosition, i), 
            itemEl = getListItem(i, places[i]); // 검색 결과 항목 Element를 생성합니다

        // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
        // LatLngBounds 객체에 좌표를 추가합니다
        bounds.extend(placePosition);

        // 마커와 검색결과 항목에 mouseover 했을때
        // 해당 장소에 인포윈도우에 장소명을 표시합니다
        // mouseout 했을 때는 인포윈도우를 닫습니다
        (function(marker, title) {
            kakao.maps.event.addListener(marker, 'mouseover', function() {
                displayInfowindow(marker, title);

            });

            kakao.maps.event.addListener(marker, 'mouseout', function() {
                infowindow.close();
            });
            
          	//마커 클릭이벤트 만들기~ -----------------------------------------------------
    	
			var overlay = new kakao.maps.CustomOverlay({
			    content: customContent,
			    map: map,
			    position: marker.getPosition()       
			});
          	
          		overlay.setMap(null);
          	
	
			//커스텀 오버레이를 만듦!		
			let flag = true;
			kakao.maps.event.addListener(marker, 'click', function() {
				
								
				if(flag==true){
				overlay.setMap(map);
				
				let lat = marker.getPosition().getLat(); //위도
				let lng = marker.getPosition().getLng(); //경도
				
				document.getElementById("hiddenLat").innerText=lat;
				document.getElementById("hiddenLng").innerText=lng;
				
				
				//해당 마커의 장소명 가져오기--------------------------------------------
				//console.log(places[i].address_name);
				//console.log(title);
				document.getElementById("hiddenTitle").innerText=title;
				
				
				flag = false;
				
				} else {
					overlay.setMap(null);
					flag=true;
				}
			});

          	//------------------------------------------------------------------------

            itemEl.onmouseover =  function () {
                displayInfowindow(marker, title);
            };

            itemEl.onmouseout =  function () {
                infowindow.close();
            };
        })(marker, places[i].place_name);

        fragment.appendChild(itemEl);
    
    }

    // 검색결과 항목들을 검색결과 목록 Element에 추가합니다
    listEl.appendChild(fragment);
    menuEl.scrollTop = 0;

    // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
    map.setBounds(bounds);
    

    
    
}


// 검색결과 항목을 Element로 반환하는 함수입니다
function getListItem(index, places) {

    var el = document.createElement('li'),
    itemStr = '<span class="markerbg marker_' + (index+1) + '"></span>' +
                '<div class="info">' +
                '   <h5>' + places.place_name + '</h5>';

    if (places.road_address_name) {
        itemStr += '    <span>' + places.road_address_name + '</span>' +
                    '   <span class="jibun gray">' +  places.address_name  + '</span>';
    } else {
        itemStr += '    <span>' +  places.address_name  + '</span>'; 
    }
                 
      itemStr += '  <span class="tel">' + places.phone  + '</span>' +
                '</div>';           

    el.innerHTML = itemStr;
    el.className = 'item';

    return el;
}

// 마커를 생성하고 지도 위에 마커를 표시하는 함수입니다
function addMarker(position, idx, title) {
    var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
        imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
        imgOptions =  {
            spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
            spriteOrigin : new kakao.maps.Point(0, (idx*46)+10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
            offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
        },
        markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
            marker = new kakao.maps.Marker({
            position: position, // 마커의 위치
            image: markerImage 
        });

    marker.setMap(map); // 지도 위에 마커를 표출합니다
    markers.push(marker);  // 배열에 생성된 마커를 추가합니다

    return marker;
}

// 지도 위에 표시되고 있는 마커를 모두 제거합니다
function removeMarker() {
    for ( var i = 0; i < markers.length; i++ ) {
        markers[i].setMap(null);
    }   
    markers = [];
}

// 검색결과 목록 하단에 페이지번호를 표시는 함수입니다
function displayPagination(pagination) {
    var paginationEl = document.getElementById('pagination'),
        fragment = document.createDocumentFragment(),
        i; 

    // 기존에 추가된 페이지번호를 삭제합니다
    while (paginationEl.hasChildNodes()) {
        paginationEl.removeChild (paginationEl.lastChild);
    }

    for (i=1; i<=pagination.last; i++) {
        var el = document.createElement('a');
        el.href = "#";
        el.innerHTML = i;

        if (i===pagination.current) {
            el.className = 'on';
        } else {
            el.onclick = (function(i) {
                return function() {
                    pagination.gotoPage(i);
                }
            })(i);
        }

        fragment.appendChild(el);
    }
    paginationEl.appendChild(fragment);
}

// 검색결과 목록 또는 마커를 클릭했을 때 호출되는 함수입니다
// 인포윈도우에 장소명을 표시합니다
 function displayInfowindow(marker, title) {
    var content = '<div style="padding:5px;z-index:1;">' + title + '</div>';

    infowindow.setContent(content);
    infowindow.open(map, marker);

    
}

 // 검색결과 목록의 자식 Element를 제거하는 함수입니다
function removeAllChildNods(el) {   
    while (el.hasChildNodes()) {
        el.removeChild (el.lastChild);
    }
}


 
 
 
 //----------------------------------------------------------------------------
 //마커 클릭 관련
 // 마커에 커서가 오버됐을 때 마커 위에 표시할 인포윈도우를 생성합니다
 
 
 //console.log("마커 확인", markers);
 
 
/* var iwContent = '<div style="padding:5px;">Hello World!</div>'; // 인포윈도우에 표출될 내용으로 HTML 문자열이나 document element가 가능합니다

// 인포윈도우를 생성합니다
var infowindow = new kakao.maps.InfoWindow({
    content : iwContent
});
 
 kakao.maps.event.addListener(marker, 'mouseover', function() {
  // 마커에 마우스오버 이벤트가 발생하면 인포윈도우를 마커위에 표시합니다
    infowindow.open(map, marker);
}); */

 
 
</script>