SELECT ;This query returns all users belonging to WH organisations (FH, SH, WTN, SBRY)
	DIRECTORY_IND = E.DIRECTORY_IND
	,  P.USERNAME 
	,  P.ACTIVE_IND
	, NAME_LAST = P.NAME_LAST
	, NAME_FIRST = P.NAME_FIRST
	, NAME_FULL_FORMATTED = P.NAME_FULL_FORMATTED
	, PHYSICIAN_IND = P.PHYSICIAN_IND
	, P_POSITION_DISP = UAR_GET_CODE_DISPLAY(P.POSITION_CD)
	, CREATE_DT_TM = P.CREATE_DT_TM
	, CONTRIBUTOR_SYSTEM = UAR_GET_CODE_DISPLAY(P.CONTRIBUTOR_SYSTEM_CD)
	, CREATED_BY = PR.NAME_FULL_FORMATTED
	, LAST_UPDATED_BY = PRS.NAME_FULL_FORMATTED
FROM
	EA_USER   E
	, PRSNL   P
	, PRSNL   PR
	, PRSNL   PRS
	, PRSNL_ORG_RELTN POR
PLAN E WHERE E.USERNAME = "*"
JOIN P WHERE P.USERNAME = E.USERNAME
 AND P.POSITION_CD != 6797458.00             /*NON-SYSTEM*/
 AND P.ACTIVE_IND = 1                                    /*ACTIVE USERS ONLY*/

/*** Comment out below 2 lines if you want to include ALL organisations ****
**** (filters by WH facilities if included)                             ***/
JOIN POR WHERE POR.PERSON_ID = P.PERSON_ID
AND POR.ORGANIZATION_ID IN (680563 /*FH*/, 680564 /*SH*/, 680565 /*WTN*/, 680566 /*SBRY*/ ) /*WH ORGS*/


JOIN PR WHERE PR.PERSON_ID = P.CREATE_PRSNL_ID 
JOIN PRS WHERE PRS.PERSON_ID = P.UPDT_ID
GROUP BY
	E.DIRECTORY_IND
	, P.USERNAME
	, P.ACTIVE_IND
	, P.NAME_LAST
	, P.NAME_FIRST
	, P.NAME_FULL_FORMATTED
	, P.PHYSICIAN_IND
	, P.POSITION_CD
	, P.CREATE_DT_TM
	, P.CONTRIBUTOR_SYSTEM_CD
	, PR.NAME_FULL_FORMATTED
	, PRS.NAME_FULL_FORMATTED

WITH NOCOUNTER, SEPARATOR=" ", FORMAT, MAXREC = 15000