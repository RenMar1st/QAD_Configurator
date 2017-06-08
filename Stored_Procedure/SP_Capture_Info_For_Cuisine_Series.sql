USE [ConfiguratorTables]
GO
/****** Object:  StoredProcedure [dbo].[CaptureInforForCuisineSeries]    Script Date: 6/8/2017 11:31:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Ren, Luo>
-- Description:	<Capture key characterastics from table CuisineSeries and populate key data into table CuisineSeries2>
-- Create date: <05-10-2017>
-- =============================================

ALTER procedure [dbo].[CaptureInforForCuisineSeries]
as
begin

delete from CuisineSeries2 ---first step, reset table CuisineSeries2

DECLARE @Model               varchar(50)   -- store Model#
DECLARE	@Desc                varchar(100)  -- store Desc for each Model
DECLARE @ModelWidth          varchar(50)   -- store Model width
DECLARE @BottomSection       varchar(50)   -- store Bottom Section data
DECLARE @NeedGriddle         varchar(50)   -- store Need Griddle data
DECLARE	@RequireHotTop       varchar(100)  -- store Require Hot Top data


DECLARE ModelCursor cursor for
select * from CuisineSeries

open ModelCursor
fetch NEXT from ModelCursor into @Model, @Desc, @ModelWidth

while @@FETCH_STATUS = 0
begin

--Make all the description lower case.
set @Desc = lower(@Desc)


--RequireTopSection data setup

begin
if @ModelWidth = '12'
	begin
	set @RequireHotTop = 
		case
			when SUBSTRING(@Model,7,4) IN ('-1  ', '-1M ') then '12 VG  '
			when SUBSTRING(@Model,7,4) = '-1-1' then '12 TG  '
			when SUBSTRING(@Model,7,4) IN ('-6  ', '-6M ') then '2 OPEN BURNERS'
			when SUBSTRING(@Model,7,4) IN ('-8  ', '-8M ') then '1 HOT TOP'
			when SUBSTRING(@Model,7,4) IN ('-15 ', '-15M') then '1 OPEN BURNER 1 FRENCH TOP'
		end
	end
else
	if @ModelWidth = '18'
		begin
		set @RequireHotTop = 
			case
				when SUBSTRING(@Model,6,4) IN ('-1  ', '-1M ') then '18 VG  '
				when SUBSTRING(@Model,6,4) = '-1-1' then '18 TG  '
				when SUBSTRING(@Model,6,4) IN ('-7  ', '-7M ', '-7M-') then '2 OPEN BURNERS'
				when SUBSTRING(@Model,6,4) IN ('-9  ', '-9M ') then '1 HOT TOP'
				when SUBSTRING(@Model,6,4) IN ('-10 ', '-10M') then '1 FRONT FIRED HOT TOP'
			end
		end
	else
		if @ModelWidth = '24'
			begin
			set @RequireHotTop = 
				case
					when SUBSTRING(@Model,7,4) IN ('-1  ' ,'-1M ') then '24 VG  '
					when SUBSTRING(@Model,7,4) = '-1-1' then '24 TG  '
				end
			end
		else
			if @ModelWidth = '36'
				begin
				set @RequireHotTop = 
					case
						when SUBSTRING(@Model,5,4) IN ('-1  ', '-1M ', '-1RC')  OR SUBSTRING(@Model,6,4) IN ('-1  ', '-1M ', '-1RC') then '36 VG  '
						when SUBSTRING(@Model,5,4) = '-1-1'  OR SUBSTRING(@Model,6,4) = '-1-1' then '36 TG  '
						when SUBSTRING(@Model,5,4) IN ('-2  ', '-2M ', '-2RC')  OR SUBSTRING(@Model,6,4) IN ('-2  ', '-2M ', '-2RC') then '24 VG, 2 OPEN BURNERS'
						when SUBSTRING(@Model,5,4) = '-2-1'  OR SUBSTRING(@Model,6,4) = '-2-1' then '24 TG, 2 OPEN BURNERS'
						when SUBSTRING(@Model,5,4) IN ('-3  ', '-3M ', '-3RC')  OR SUBSTRING(@Model,6,4) IN ('-3  ', '-3M ', '-3RC') then '24 VG, 1 HOT TOP'
						when SUBSTRING(@Model,5,4) = '-3-1'  OR SUBSTRING(@Model,6,4) = '-3-1' then '24 TG, 1 HOT TOP'
						when SUBSTRING(@Model,5,4) IN ('-4  ', '-4M ', '-4RC')  OR SUBSTRING(@Model,6,4) IN ('-4  ', '-4M ', '-4RC') then '18 VG, 2 OPEN BURNERS'
						when SUBSTRING(@Model,5,4) = '-4-1'  OR SUBSTRING(@Model,6,4) = '-4-1' then '18 TG, 2 OPEN BURNERS'
						when SUBSTRING(@Model,5,4) IN ('-5  ', '-5M ', '-5RC')  OR SUBSTRING(@Model,6,4) IN ('-5  ', '-5M ', '-5RC') then '18 VG, 1 HOT TOP'
						when SUBSTRING(@Model,5,4) = '-5-1'  OR SUBSTRING(@Model,6,4) = '-5-1' then '18 TG, 1 HOT TOP'
						when SUBSTRING(@Model,5,4) IN ('-6  ', '-6M ', '-6RC')  OR SUBSTRING(@Model,6,4) IN ('-6  ', '-6M ', '-6RC') then '6 OPEN BURNERS'
						when SUBSTRING(@Model,5,4) = '-6SU'  OR SUBSTRING(@Model,6,4) = '-6SU' then '6 STEP UP OPEN BURNERS'
						when SUBSTRING(@Model,5,4) IN ('-7  ', '-7M ', '-7RC')  OR SUBSTRING(@Model,6,4) IN ('-7  ', '-7M ', '-7RC') then '4 OPEN BURNERS'
						when SUBSTRING(@Model,5,4) IN ('-8  ', '-8M ', '-8RC')  OR SUBSTRING(@Model,6,4) IN ('-8  ', '-8M ', '-8RC') then '3 HOT TOPS'
						when SUBSTRING(@Model,5,4) IN ('-9  ', '-9M ', '-9RC')  OR SUBSTRING(@Model,6,4) IN ('-9  ', '-9M ', '-9RC') then '2 HOT TOPS'
						when SUBSTRING(@Model,5,5) IN ('-10  ', '-10M ', '-10RC')  OR SUBSTRING(@Model,6,5) IN ('-10  ', '-10M ', '-10RC') then '2 FRONT FIRED HOT TOPS'
						when SUBSTRING(@Model,5,5) IN ('-11  ', '-11M ', '-11RC')  OR SUBSTRING(@Model,6,5) IN ('-11  ', '-11M ') then '1 HOT TOP, 1 FRONT FIRED HOT TOP'
						when SUBSTRING(@Model,5,5) in ('-11R ', '-11RR')  OR SUBSTRING(@Model,6,5) IN ('-11R ', '-11RM') then '1 FRONT FIRED HOT TOP, 1 HOT TOP'
						when SUBSTRING(@Model,5,5) IN ('-12  ', '-12M ', '-12RC')  OR SUBSTRING(@Model,6,4) IN ('-12 ', '-12M') then '2 OPEN BURNERS, 2 HOT TOPS'
						when SUBSTRING(@Model,5,4) = '-12C'  OR SUBSTRING(@Model,6,4) = '-12C' then '1 HOT TOP, 2 OPEN BURNERS CENTER, 1 HOT TOP '
						when SUBSTRING(@Model,5,5) in ('-12R ', '-12RR')  OR SUBSTRING(@Model,6,5) IN ('-12R ', '-12RM') then '2 HOT TOPS, 2 OPEN BURNERS'
						when SUBSTRING(@Model,5,5) IN ('-13  ', '-13M ', '-13RC')  OR SUBSTRING(@Model,6,5) IN ('-13  ', '-13M ', '-13RC') then '4 OPEN BURNERS, 1 HOT TOP'
						when SUBSTRING(@Model,5,4) = '-13C'  OR SUBSTRING(@Model,6,4) = '-13C' then '2 OPEN BURNERS , 1 HOT TOP, 2 OPEN BURNERS'
						when SUBSTRING(@Model,5,4) = '-13L'  OR SUBSTRING(@Model,6,4) = '-13L' then '1 HOT TOP, 4 OPEN BURNERS'
						when SUBSTRING(@Model,5,5) IN ('-14  ', '-14M ', '-14RC')  OR SUBSTRING(@Model,6,5) IN ('-14  ', '-14M ', '-14RC') then '2 OPEN BURNERS, 1 HOT TOP'
						when SUBSTRING(@Model,5,4) = '-14L'  OR SUBSTRING(@Model,6,4) = '-14L' then '1 HOT TOP, 2 OPEN BURNERS'
						when SUBSTRING(@Model,5,5) IN ('-15  ', '-15M ', '-15RC')  OR SUBSTRING(@Model,6,4) IN ('-15  ', '-15M ', '-15RC') then '3 OPEN BURNERS 3 FRENCH TOPS'
						when SUBSTRING(@Model,5,5) IN ('-17  ', '-17M ', '-17RC')  OR SUBSTRING(@Model,6,5) IN ('-17  ', '-17M ', '-17RC') then '1 FRONT FIRED HOT TOP, 2 OPEN BURNERS'
						when SUBSTRING(@Model,5,4) = '-17R'  OR SUBSTRING(@Model,6,4) = '-17R' then '2 OPEN BURNERS, 1 FRONT FIRED HOT TOP'
					end
				end
			else
				begin
				set @RequireHotTop = 
					case
						when SUBSTRING(@Model,5,5) IN ('-48 ','-48RC','-48M ') OR SUBSTRING(@Model,6,5) IN ('-48 ','-48RC', '-48M') then '48 VG  '
						when SUBSTRING(@Model,5,5) = '-48-1' OR SUBSTRING(@Model,6,5) = '-48-1' then '48 TG  '
					end
				end
end


begin
if @Desc like '%spreader%'
	set @RequireHotTop = 'N'
end

--NeedGriddle data setup

begin
if @RequireHotTop like '%VG%' or @RequireHotTop like '%TG%'
	begin
	set @NeedGriddle = SUBSTRING(@RequireHotTop,1,5)
	end
else
	begin
	set @NeedGriddle = 'N'
	end
end


--BottomSection data setup

begin
if @ModelWidth = '12'
	begin
	if RIGHT(@Model,1) = 'M'
		begin
		set @BottomSection = 'NONE/MODULAR TOP'
		end
	else
		begin
		set @BottomSection = '1 STORAGE BASE'
		end
	end
else
	if @ModelWidth = '18'
		begin
		if RIGHT(@Model,1) = 'M'
			begin
			set @BottomSection = 'NONE/MODULAR TOP'
			end
		else
			begin
			set @BottomSection = '1 STORAGE BASE'
			end
		end
	else
		if @ModelWidth = '24'
			begin
			if RIGHT(@Model,1) = 'M'
				begin
				set @BottomSection = 'NONE/MODULAR TOP'
				end
			else
				begin
				set @BottomSection = '1 STORAGE BASE'
				end
			end
		else
			if @ModelWidth = '36'
				begin
				if SUBSTRING(@Model,2,1) = '0'
					begin
					if RIGHT(@Model,1) = 'M'
						begin
						set @BottomSection = 'NONE/MODULAR TOP'
						end
					else
						begin
						set @BottomSection = '1 STORAGE BASE'
						end
					end
				else
					begin
					if RIGHT(@Model,2) = 'RC'
						begin
						set @BottomSection = 'CONV OVEN'
						end
					else
						begin
						set @BottomSection = 'STD OVEN'
						end
					end
				end
			else
				begin			
				if SUBSTRING(@Model,2,1) = '0'
					begin
					if RIGHT(@Model,1) = 'M'
						begin
						set @BottomSection = 'NONE/MODULAR TOP'
						end
					else
						begin
						set @BottomSection = '1 36" STORAGE BASE, 1 12" STORAGE BASE'
						end
					end
				else
					begin
					if RIGHT(@Model,2) = 'RC'
						begin
						set @BottomSection = '1 36" CONV OVEN, 1 12" STORAGE BASE'
						end
					else
						begin
						set @BottomSection = '1 36" STD OVEN, 1 12" STORAGE BASE'
						end
					end			
				end
end	

/* This model is obsolete
begin
if @Model = 'C1836-7M-3'
	SET @BottomSection = 'SHORT LEGS'
end
*/

begin
if @Desc like '%spreader%'
	set @BottomSection = 
		case
			when @Desc like '%cabinet%' then '1 STORAGE BASE'
			when @Desc like '%plate%'   then 'NONE/MODULAR TOP'
		end
end

--WidthLeft setup
declare @WidthLeft int

begin
if @NeedGriddle = 'N'
	begin
	set @WidthLeft = cast(@ModelWidth as int)
	end
else
	begin
	set @WidthLeft = cast(@ModelWidth as int) - cast(SUBSTRING(@NeedGriddle,1,2) as int)
	end
end



--Update RequireHotTop columns
begin
if @NeedGriddle <> 'N'
	begin
	if @WidthLeft = 0
		begin
		set @RequireHotTop = 'N'
		end
	else
		begin
		set @RequireHotTop = REPLACE(@RequireHotTop, SUBSTRING(@RequireHotTop,1,7), '')
		end
	end
else		
	set @RequireHotTop = @RequireHotTop
end


--Populate all usefull info into table CuisineSeries2

insert into CuisineSeries2
select @Model, @Desc, @ModelWidth, @BottomSection, @NeedGriddle, @WidthLeft,@RequireHotTop



fetch NEXT from ModelCursor into @Model, @Desc, @ModelWidth
end
close ModelCursor
deallocate ModelCursor

end


