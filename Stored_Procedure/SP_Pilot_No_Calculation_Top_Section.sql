USE [ConfiguratorTables]
GO
/****** Object:  StoredProcedure [dbo].[SP_PilotNoCalculationTopSection]    Script Date: 6/8/2017 11:25:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SP_PilotNoCalculationTopSection]

AS
BEGIN



declare @NoOfPilots INT -------- how many pilots this unit comes with in the top section

declare @T1 nvarchar(50)
declare @T2 nvarchar(50)
declare @T3 nvarchar(50)
declare @T4 nvarchar(50)
declare @T5 nvarchar(50)

delete from PilotNoCalculationTopSectionResult

DECLARE TopSection cursor for
select T1, T2, T3, T4, T5 from PilotNoCalculationTopSection

open TopSection
fetch NEXT from TopSection into @T1,@T2, @T3,@T4,@T5

while @@FETCH_STATUS = 0
begin

set @NoOfPilots = 0
		+ 
		case
			when @T1 = 'NA' THEN 0
			when @T1 = 'OB' THEN 2
			when @T1 = 'HT' THEN 1
		end
		+
		case
			when @T2 = 'NA' THEN 0
			when @T2 = 'OB' THEN 2
			when @T2 = 'HT' THEN 1
		end
		+
		case
			when @T3 = 'NA' THEN 0
			when @T3 = 'OB' THEN 2
			when @T3 = 'HT' THEN 1
		end
		+	
		case
			when @T4 = 'NA' THEN 0
			when @T4 = 'OB' THEN 2
			when @T4 = 'HT' THEN 1
		end
		+
		case
			when @T5 = 'NA' THEN 0
			when @T5 = 'OB' THEN 2
			when @T5 = 'HT' THEN 1
		end


insert into [dbo].[PilotNoCalculationTopSectionResult]
select @T1, @T2, @T3, @T4, @T5, cast(@NoOfPilots as nvarchar)



fetch NEXT from TopSection into @T1,@T2, @T3,@T4,@T5
end
close TopSection
deallocate TopSection



END

