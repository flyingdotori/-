/*각 지역의 캠핑장 조히*/

select * from camping_info;

# 1. 캠핑장의 사업장명(NAME)과 소재지전체주소(ADDRESS) 출력
select 사업장명 as NAME, 소재지전체주소 as ADDRESS from camping_info;

# 2. 정상영업하고 있는 캠핑장만 출력
select 사업장명 as NAME, 소재지전체주소 as ADDRESS from camping_info where 영업상태명 = '영업/정상'; # 영업상태구분코드=1

# 3. 양양에 위치한 캠핑장은 몇개인지 출력
select count(*) from camping_info where 소재지전체주소 like '%양양군%';

# 4. 3번 데이터에서 폐업한 캠핑장은 몇개인지 출력
select count(*)  from camping_info where 소재지전체주소 like '%양양군%' and 영업상태구분코드=3;
 
# 5. 태안에 위치한 캠핑장의 사업장명 출력
select 사업장명 from camping_info where 소재지전체주소 like ('%태안%');
 
# 6. 5번 데이터에서 2020년에 폐업한 캠핑장 출력 
select 사업장명, 폐업일자 from camping_info where 소재지전체주소 like '%태안%' and 폐업일자 like '2020%';
 
# 7. 제주도와 서울에 위치한 캠핑장의 개수 줄력
select count(*)  from camping_info where 소재지전체주소 like '%서울%' or 소재지전체주소 like '%제주%';



/*해수욕장에 위치한 캠핑장*/

# 1. 해수욕장에 위치한 캠핑장의 사업장명과 인허가일자 출력
select 사업장명, 인허가일자 from camping_info where 사업장명 like '%해수욕장%';

# 2. 제주도 해수욕장에 위치한 캠핑장의 소재지전체주소와 사업장명 출력
select 사업장명, 소재지전체주소 from camping_info where 사업장명 like '%해수욕장%' and 소재지전체주소 like '%제주%';

# 3. 2번 데이터에서 인허가일자가 가장 최근인 곳의 인허가일자 출력
select max(인허가일자) from camping_info where 사업장명 like '%해수욕장%' and 소재지전체주소 like '%제주%';

# 4. 강원도 해수욕장에 위치한 캠핑장 중 영업중인 곳만 출력
select 사업장명, 상세영업상태명 from camping_info where 소재지전체주소 like '%강원%' and  사업장명 like '%해수욕장%' and 영업상태구분코드 = 1;

# 5. 4번 데이터 중 인허가일자가 가장 오래된 것의 인허가일자 출력
select min(인허가일자) from camping_info where 소재지전체주소 like '%강원%' and  사업장명 like '%해수욕장%' and 영업상태구분코드 = 1;

# 6. 해수욕장에 위치한 캠핑장 중 시헐면적이 가장 넓은 곳의 시설면적 출력
select max(시설면적) from camping_info where 사업장명 like '%해수욕장%';
 
# 7. 해수욕장에 위치한 캠핑장의 평균 시설면적 출력
select avg(시설면적) from camping_info where 사업장명 like '%해수욕장%';