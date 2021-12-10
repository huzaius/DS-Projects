
/******************

SQL DATA CLEANING 

*******************/

select * from PorfolioProject..NashvilleHousing;


-----------------	Standardized Date Format ----------------------------
select SaleDate,CONVERT(Date,SaleDate) as 
from PorfolioProject..NashvilleHousing;

--Update NashvilleHousing
--SET SaleDate = CONVERT(Date,SaleDate);

ALTER TABLE NashvilleHousing
add ConvertedSalesDate Date;

Update NashvilleHousing
SET ConvertedSalesDate = CONVERT(Date,SaleDate);



----------			Property Address			-------------------------
select * from NashvilleHousing
where PropertyAddress is null


select ParcelID, count(ParcelID)
from NashvilleHousing
group by ParcelID
having count(ParcelID)>1

select ParcelID,PropertyAddress from NashvilleHousing
where ParcelID in ('015 14 0 060.00',
'018 00 0 164.00',
'018 07 0 045.00',
'018 07 0 109.00',
'018 07 0 142.00',
'018 07 0 150.00',
'018 08 0 015.00')		----It is seen that unique ParcelID's have the same PropertyAddress.




select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) --ISNULL replace firstnull with second value)
from NashvilleHousing a
JOIN  NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null


Update a
SET PropertyAddress =  ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
JOIN  NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

---------------			 Seggrigating Address into Address, City and State			----------------------------
----PropertyAddress
select PropertyAddress 
from NashvilleHousing

select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)) as Address,
CHARINDEX(',',PropertyAddress)
from NashvilleHousing


select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+2,LEN(PropertyAddress)) 
from NashvilleHousing


ALter table NashvilleHousing
Add PropertyAddressOnly nvarchar(255)

ALter table NashvilleHousing
Add PropertyCity nvarchar(255);

Update NashvilleHousing
SET PropertyAddressOnly = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Update NashvilleHousing
SET PropertyCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+2,LEN(PropertyAddress)) 


---- OwnersAddress
select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM NashvilleHousing

alter table NashvilleHousing
Add OwnerAddressOnly nvarchar(255)

alter table NashvilleHousing
Add OwnerCity nvarchar(255)

alter table NashvilleHousing
Add OwnerState nvarchar(255)

Update NashvilleHousing
SET OwnerAddressOnly = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Update NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Update NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)



---------------			Changing Yes and No in SoldAsVacant			------------------------
select Distinct(SoldAsVacant) ,Count(SoldAsVacant)
from NashvilleHousing
Group by SoldAsVacant
order by 1

select SoldAsVacant,
CASE	WHEN SoldAsVacant = 'Y' THEN 'YES'
		WHEN SoldAsVacant = 'N' THEN 'NO'
		ELSE SoldAsVacant
		END
FROM NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE	WHEN SoldAsVacant = 'Y' THEN 'YES'
		WHEN SoldAsVacant = 'N' THEN 'NO'
		ELSE SoldAsVacant
		END;



-----------------		Removing Duplicates					-------------------------------
----	Assuming ParcelID, PropertyAddress,SalePrice,SaleDate,LegalReference as Unique Values
WITH RowNumCTE AS(
select * ,
ROW_NUMBER() OVER 
				(PARTITION BY ParcelID,
							  PropertyAddress,
							  SalePrice,
							  SaleDate,
							  LegalReference
							  ORDER BY
								UniqueID
								) row_num

from NashvilleHousing
--order by ParcelID
)
select * from RowNumCTE
where row_num>1
order by PropertyAddress


CREATE OR REPLACE VIEW NashvilleHousingView
AS
select * EXCEPT(OwnerAddress,TaxDistrict,PropertyAddress,SaleDate)
from NashvilleHousing

-----------------------			REMOVING UNSUED COLUMNS				------------------------

select * from PorfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress,SaleDate





