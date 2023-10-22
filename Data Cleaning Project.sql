create database db_Data
use db_Data


Cleaning Data in SQL Queries



Select * 
from [dbo].[Nashville_Housing]
--------------------------------------------------------------------------------------------------------------------------
-- Standardize Date Format

Select SaleDate,convert(Date,SaleDate) 
from [dbo].[Nashville_Housing]

Update Nashville_Housing
set SaleDate=convert(Date,SaleDate) 


-- If it doesn't Update properly

Alter Table [dbo].[Nashville_Housing]
Add SaleDateconverted date;

Update Nashville_Housing
set SaleDateconverted=convert(Date,SaleDate) 


--------------------------------------------------------------------------------------------------------------------------
-- Populate Property Address data

Select [PropertyAddress]
from [dbo].[Nashville_Housing]
where [PropertyAddress] is null

Select *
from [dbo].[Nashville_Housing]
--where [PropertyAddress] is null
order by [ParcelID]

Select *
from [dbo].[Nashville_Housing] a
join [dbo].[Nashville_Housing] b
on a.[ParcelID]=b.[ParcelID]
and a.[UniqueID ]<>b.[UniqueID ]

Select a.[ParcelID],a.[PropertyAddress],b.[ParcelID],b.[PropertyAddress], isnull(a.[PropertyAddress],b.[PropertyAddress])
from [dbo].[Nashville_Housing] a
join [dbo].[Nashville_Housing] b
on a.[ParcelID]=b.[ParcelID]
and a.[UniqueID ]<>b.[UniqueID ]
where a.[PropertyAddress] is null

update a
set [PropertyAddress]=isnull(a.[PropertyAddress],b.[PropertyAddress])
from [dbo].[Nashville_Housing] a
join [dbo].[Nashville_Housing] b
on a.[ParcelID]=b.[ParcelID]
and a.[UniqueID ]<>b.[UniqueID ]
where a.[PropertyAddress] is null

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select [PropertyAddress]
from [dbo].[Nashville_Housing]
--where [PropertyAddress] is null
--order by [ParcelID]

select
SUBSTRING([PropertyAddress], 1, CHARINDEX(',',[PropertyAddress])-1) as address
,SUBSTRING([PropertyAddress], CHARINDEX(',',[PropertyAddress])+1, len([PropertyAddress])) as address
from [dbo].[Nashville_Housing]

Alter Table [dbo].[Nashville_Housing]
Add PropertySplitAddress Nvarchar(255);

Update Nashville_Housing
set PropertySplitAddress=SUBSTRING([PropertyAddress], 1, CHARINDEX(',',[PropertyAddress])-1)

Alter Table [dbo].[Nashville_Housing]
Add PropertySplitCity Nvarchar(255);

Update Nashville_Housing
set PropertySplitCity=SUBSTRING([PropertyAddress], CHARINDEX(',',[PropertyAddress])+1, len([PropertyAddress]))

.
Select * 
from [dbo].[Nashville_Housing]

Select [OwnerAddress]
from [dbo].[Nashville_Housing]  

select
parsename(replace([OwnerAddress],',','.'), 3)
,parsename(replace([OwnerAddress],',','.'), 2)
,parsename(replace([OwnerAddress],',','.'), 1)
from [dbo].[Nashville_Housing]  

Alter Table [dbo].[Nashville_Housing]
Add OwnerSplitAddress Nvarchar(255);

Update Nashville_Housing
set OwnerSplitAddress= parsename(replace([OwnerAddress],',','.'), 3)

Alter Table [dbo].[Nashville_Housing]
Add OwnerSplitCity Nvarchar(255);

Update Nashville_Housing
set OwnerSplitcity=parsename(replace([OwnerAddress],',','.'), 2)

Alter Table [dbo].[Nashville_Housing]
Add OwnerSplitState Nvarchar(255);

Update Nashville_Housing
set OwnerSplitState=parsename(replace([OwnerAddress],',','.'), 1)

Select * 
from [dbo].[Nashville_Housing]

--------------------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field

 

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [dbo].[Nashville_Housing]
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [dbo].[Nashville_Housing]


Update [dbo].[Nashville_Housing]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Remove Duplicates



WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [dbo].[Nashville_Housing]
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From [dbo].[Nashville_Housing]

---------------------------------------------------------------------------------------------------------
-- Delete Unused Columns

Select *
From [dbo].[Nashville_Housing]


ALTER TABLE [dbo].[Nashville_Housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

