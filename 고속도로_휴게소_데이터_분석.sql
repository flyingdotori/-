/*JOIN*/

# 1.고속도로 휴게소의 규모와 주차장 현황
select rs.휴게소명, rs.시설구분, rp.합계 ,rp.대형, rp.소형, rp.장애인 
 from rest_area_score rs left outer join rest_area_parking rp
 on rs.휴게소명 = rp.휴게소명
union
select rp.휴게소명, rs.시설구분, rp.합계 ,rp.대형, rp.소형, rp.장애인 
 from rest_area_parking rp left outer join rest_area_score rs
 on rs.휴게소명 = rp.휴게소명;

# 2. 고속도로 휴게소의 규모의 화장실 현황
select rs.휴게소명, rs.시설구분, rr.남자_변기수, rr.여자_변기수
 from rest_area_score rs left outer join rest_area_restroom rr
 on rs.휴게소명 = rr.시설명
union
select rr.시설명, rs.시설구분, rr.남자_변기수, rr.여자_변기수
 from rest_area_restroom rr left outer join rest_area_score rs
 on rs.휴게소명 = rr.시설명;
 
# 3. 고속도로 휴게소의 규모, 주차장, 화장실 현황을 출력
select ras.휴게소명, ras.시설구분, rap.합계, rar.남자_변기수, rar.여자_변기수
 from rest_area_score ras, rest_area_restroom rar, rest_area_parking rap
 where ras.휴게소명 = rar.시설명 
 and rar.시설명 = rap.휴게소명;

# 4. 고속도로 휴게소 규모별 주차장 수 합계의 평균, 최소값, 최대값
select ras.휴게소명, ras.시설구분,
		avg(rap.합계) over(partition by ras.시설구분) as avg_parking,
		min(rap.합계) over(partition by ras.시설구분) as min_parking,
		max(rap.합계) over(partition by ras.시설구분) as max_parking
 from rest_area_score ras inner join rest_area_parking rap
 on ras.휴게소명 = rap.휴게소명;

#5. 고속도로 휴게소 만족도별 대형 주차장 수가 가장 많은 휴게소
select t.휴게소명, t.평가등급, t.대형
 from(
	select ras.휴게소명, ras.평가등급, rap.대형,
			rank() over(partition by ras.평가등급 order by rap.대형) as rnk
	 from rest_area_score ras, rest_area_parking rap
	 where ras.휴게소명 = rap.휴게소명
	) t
where rnk=1;



/* 전국 휴게소의 화장실 실태 조사 */

# 1. 노선별 남자 변기수, 여자 변기수 최대값

# group by
select 노선, max(남자_변기수), max(여자_변기수) 
 from rest_area_restroom
 group by 노선;

# 윈도우 함수
select distinct 노선,
	max(남자_변기수) over(partition by 노선) as max_man,
	max(여자_변기수) over(partition by 노선) as max_wom
 from rest_area_restroom;


# 2. 휴게소 중 total 변기 수가 가장 많은 휴게소
select 시설명, 남자_변기수+여자_변기수 total
 from rest_area_restroom
 order by total desc
 limit 1;
 

# 3. 노선별로 남자_변기수, 여자_변기수의 평균값
select 노선, round(avg(남자_변기수)), round(avg(여자_변기수))
 from rest_area_restroom
 group by 노선;


# 4. 노선별로 total 변기수가 가장 많은 곳
select t.노선, t.시설명, t.total 
 from(
	 select 노선, 시설명, 남자_변기수+여자_변기수 as total,
	  rank() over(partition by 노선 order by 남자_변기수+여자_변기수 desc) as rnk_total
	  from rest_area_restroom
   ) t
 where t.rnk_total = 1; 


# 5. 노선별 남자 변기수가 더 많은 곳, 여자 변기수가 더 많은 곳, 남녀 변기수가 동일한 곳의 count
select 노선,
		count(case when 남자_변기수 > 여자_변기수 then 1 end) as male,
		count(case when 남자_변기수 < 여자_변기수 then 1 end) as female,
		count(case when 남자_변기수 = 여자_변기수 then 1 end) as equal
 from rest_area_restroom
group by 노선;



/*만족도가 높은 휴게소의 편의시설 현황*/

# 1. 평가등급이 최우수인 휴게소의 장애인 주차장 수(휴게소명, 시설구분, 주차장수 내림차순)
select ras.휴게소명, ras.시설구분 , rap.장애인
 from rest_area_score ras left outer join rest_area_parking rap
 on ras.휴게소명 = rap.휴게소명
 where ras.평가등급 = '최우수'
 order by rap.장애인 desc;

# 서브쿼리-인라인뷰
select s.휴게소명, s.시설구분, rap.장애인
 from (
	select 휴게소명,시설구분, 평가등급
	 from rest_area_score
	 where 평가등급 = '최우수'
	)s left outer join rest_area_parking rap
		on s.휴게소명 = rap.휴게소명
 order by rap.장애인 desc;


# 2. 평가등급이 우수인 휴게소의 장애인 주차장 수 비율(휴게소명, 시설구분, 주차장수 내림차순)
select ras.휴게소명, ras.시설구분,round(rap.장애인/rap.합계*100,2) as ratio
 from rest_area_score ras left outer join rest_area_parking rap
 on ras.휴게소명 = rap.휴게소명
 where ras.평가등급 = '우수'
 order by per desc;

# 서브쿼리-인라인뷰
 select s.휴게소명, s.시설구분, round(rap.장애인/rap.합계*100,2) as ratio
 from (
	select 휴게소명,시설구분, 평가등급
	 from rest_area_score
	 where 평가등급 = '우수'
	)s left outer join rest_area_parking rap
		on s.휴게소명 = rap.휴게소명
 order by per desc;
 

# 3. 휴게소의 시설구분별 주차장 수 합계의 평균
select ras.시설구분, round(avg(rap.합계)) as avg_total
 from rest_area_score ras, rest_area_parking rap
 where ras.휴게소명 = rap.휴게소명 
 group by ras.시설구분 

# left outer join
select ras.시설구분, round(avg(rap.합계)) as avg_total
 from rest_area_score ras left outer join rest_area_parking rap
 on ras.휴게소명 = rap.휴게소명 
 group by ras.시설구분 


# 4. 노선별 대형차를 가장 많이 주차할 수 있는 휴게소 top3
select t.노선, t.휴게소명, t.대형
 from(
		select 노선, 대형, 휴게소명,
			rank() over(partition by 노선 order by 대형 desc) as rnk
	     from rest_area_parking rap
	) t
 where t.rnk < 4;


# 5. 본부별 소형차를 가장 많이 주차할 수 있는 휴게소 top3
select t.본부, t.휴게소명, t.소형
 from(
		select 본부, 소형, 휴게소명,
			rank() over(partition by 본부 order by 소형 desc) as rnk
	     from rest_area_parking rap
	) t
 where t.rnk < 4;
 


/*반려동물을 데리고 와이파이 빵빵한 휴게소에 가기*/

# 1. 반려동물 놀이터가 있는 휴게소 중 wifi 사용이 가능한 곳

# rest_area_animal의 데이터가 모두 반려동물 놀이터가 있는 것을 확인
select *
 from rest_area_animal raa, rest_area_wifi raw
 where raa.휴게소명 = raw.휴게소명 and raw.가능여부 = 'O';

# left outer join
select *
 from rest_area_animal raa left outer join rest_area_wifi raw
 on raa.휴게소명 = raw.휴게소명
 where 가능여부 = 'O';


# 2. 반려동물 놀이터가 있는 휴게소 중 운영시간이 24시간인 곳은 몇 군데인가
select count(*)
 from rest_area_animal
 where 운영시간 = '24시간';


# 3. 본부별로 wifi 사용이 가능한 휴게소가 몇 군데인가
# '충북', ' 충북' 데이터 합치기
select trim(본부), count(*)
 from rest_area_wifi raw
 where 가능여부='O'
 group by trim(본부);


# 4. 3번 데이터를 휴게소가 많은 순서대로 정렬
select trim(본부), count(*)
 from rest_area_wifi raw
 where 가능여부='O'
 group by trim(본부)
 order by count(*) desc;


# 5. 4번 데이터에서 휴게소 수가 25보다 많은 곳
select trim(본부), count(*)
 from rest_area_wifi raw
 where 가능여부='O'
 group by trim(본부)
 having count(*)>25
 order by count(*) desc;