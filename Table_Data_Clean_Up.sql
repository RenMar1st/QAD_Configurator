-----delete OBSOLETE models in tblBomParts

delete from tblBomParts 
where Model in (select Model from [dbo].[CP_SeriesVSModelsVSMarket] where [QAD Status] = 'OBSOLETE')

delete from tblBomParts 
where Model in (select Model from tblSeriesGA where Series in ('MPCOGas','MPCOElec','G24','AP','CPO'))


--USE tblBomParts2 as working table
delete from tblBomParts2
insert into tblBomParts2
select * from tblBomParts

DELETE FROM tblBomParts2
WHERE BOM01 IN (select Part from [dbo].[OptionsInCameleonWithStatus] where Status = 'OBSOLETE' OR Status is null)

DELETE FROM tblBomParts2
WHERE BOM02 IN (select Part from [dbo].[OptionsInCameleonWithStatus] where Status = 'OBSOLETE' OR Status is null)


update tblBomParts2
set BOM01Desc = 
(
select [Description] from PartUsed
where Part# = tblBomParts2.BOM01
)

update tblBomParts2
set BOM02Desc = 
(
select [Description] from PartUsed
where Part# = tblBomParts2.BOM02
)

---delete Obsolete models in tblSeriesGA

delete from tblSeriesGA 
where Model in (select Model from [dbo].[CP_SeriesVSModelsVSMarket] where [QAD Status] = 'OBSOLETE')

delete from tblSeriesGA 
where Series in ('MPCOGas','MPCOElec','G24','AP','CPO')


--delete from tblSeriesGA

-----------import into table CP_SeriesVSModels


delete from [CP_SeriesVSModels]
insert into [CP_SeriesVSModels]
select Series, Model, ModelDescReal, '', C, U, E from tblSeriesGA where Site <> 'Accessories'


select Model,ModelDescReal, Width from tblSeriesGA where Series = 'Grill' and Width <> '' order by Width


select * from [dbo].[CP_SeriesVSModels] where Model = 'SCG-24SS' order by Series, Model

select Model,ModelDescReal, Width from tblSeriesGA where Series in ('FullSizeCOEl','FullSizeCOGs')  order by Width


select Model,ModelDescReal, Width from tblSeriesGA where Series in ('S680Mount')  order by Model, Width


select Site, Series, Model,ModelDescReal, Width from tblSeriesGA where Model in ('G24-BRL')  order by Model








