create table gdelt.event
(
id varchar
, Day int
, month_year varchar
, year varchar
, fraction_date float
, Actor1Code varchar
, Actor1Name varchar
, Actor1CountryCode varchar
, Actor1KnownGroupCode varchar
, Actor1EthnicCode varchar 
, Actor1Religion1Code varchar
, Actor1Religion2Code varchar
, Actor1Type1Code varchar
, Actor1Type2Code varchar
, Actor1Type3Code varchar
, Actor2Code varchar
, Actor2Name varchar
, Actor2CountryCode varchar
, Actor2KnownGroupCode varchar
, Actor2EthnicCode varchar 
, Actor2Religion1Code varchar
, Actor2Religion2Code varchar
, Actor2Type1Code varchar
, Actor2Type2Code varchar
, Actor2Type3Code varchar
, IsRootEvent int
, EventCode varchar
, EventBaseCode varchar
, EventRootCode varchar 
, QuadClass varchar
, GoldsteinScale float
, NumMentions int
, NumSources int
, NumArticles int
, AvgTone numeric
, Actor1Geo_Type int
, Actor1Geo_Fullname varchar
, Actor1Geo_CountryCode varchar
, Actor1Geo_ADM1Code varchar
, Actor1Geo_ADM2Code varchar
, Actor1Geo_Lat float
, Actor1Geo_Long float
, Actor1Geo_FeatureID varchar
, Actor2Geo_Type int
, Actor2Geo_Fullname varchar
, Actor2Geo_CountryCode varchar
, Actor2Geo_ADM1Code varchar
, Actor2Geo_ADM2Code varchar
, Actor2Geo_Lat float
, Actor2Geo_Long float
, Actor2Geo_FeatureID varchar
, ActionGeo_Type int
, ActionGeo_Fullname varchar
, ActionGeo_CountryCode varchar
, ActionGeo_ADM1Code varchar
, ActionGeo_ADM2Code varchar
, ActionGeo_Lat float
, ActionGeo_Long float
, ActionGeo_FeatureID varchar
, DATEADDED bigint
, SOURCEURL varchar
)

drop table gdelt.event

\copy gdelt.event from /home/shivan/school/jaar_4/datascience-films/resources/gdelt_event.csv delimiter E'\t' csv header;

create table gdelt.mention
(
id varchar
, EventTimeDate bigint
, MentionTimeDate bigint
, MentionType int
, MentionSourceName varchar 
, MentionIdentifier varchar 
, SentenceID int 
, Actor1CharOffset int 
, Actor2CharOffset int
, ActionCharOffset int 
, InRawText int
, Confidence int 
, MentionDocLen int 
, MentionDocTone float 
, MentionDocTranslationInfo varchar
, Extras varchar
)

drop table gdelt.mention


\copy gdelt.mention from /home/shivan/school/jaar_4/datascience-films/resources/gdelt_mention.csv delimiter E'\t' csv header;

create table gdelt.knowledge
(
id varchar
, V2DATE bigint
, V2SOURCECOLLECTIONIDENTIFIER  varchar
, V2SUBSOURCECOMMONNAME varchar
, V2DOCUMENTIDENTIFIER varchar
, V1COUNTS varchar --[;]
, V2COUNTS varchar --[;]
, V1THEMES varchar --[;]
, V2ENHANCEDTHEMES varchar
, V1LOCATIONS varchar --[;]
, V2ENHANCEDLOCATIONS varchar --[;]
, V1PERSONS varchar --[;]
, V2ENHANCEDPERSONS varchar --[;]
, V1ORGANIZATIONS varchar -- [;] 
, V2ENHANCEDORGANIZATIONS varchar --[;]
, V1_5TONE varchar --[,]
, V2ENHANCEDDATES varchar --[;]
, V2GCAM varchar --[,] --key-value pairs
, V2SHARINGIMAGE varchar --[;] textual url 
, V2RELATEDIMAGES varchar --[;] semicolon delimited list url
, V2SOCIALIMAGEEMBEDS varchar --[;] semicolon delimited list url
, V2SOCIALVIDEOEMBEDS varchar --[;] semicolon delimited list url 
, V2QUOTATIONS varchar -- (pound-delimited  (“#”) blocks,  with  pipe-delimited  (“|”)  fields)
, V2ALLNAMES varchar -- (semicolon-delimited blocks, with comma-delimited fields)
, V2AMOUNTS varchar --(semicolon-delimited blocks, with comma-delimited fields)
, V2TRANSLATIONINFO varchar --  (semicolon-delimited  fields)  
)

drop table gdelt.knowledge


\copy gdelt.knowledge from /home/shivan/school/jaar_4/datascience-films/resources/gdelt_knowlegde.csv delimiter E'\t' csv header;
