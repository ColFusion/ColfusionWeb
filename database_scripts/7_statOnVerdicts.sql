create view statOnVerdicts as
SELECT cl1, cl2, count(*) as numberOfVerdicts, 
	SUM(if(confidence > 0, 1, 0)) AS numberOfApproved, 
	SUM(if(confidence < 0, 1, 0)) AS numberOfReject,
	SUM(if(confidence = 0, 1, 0)) AS numberOfNotSure,
	AVG(confidence) AS avgConfidence
FROM colfusion_user_relationship_verdict
group by cl1, cl2
