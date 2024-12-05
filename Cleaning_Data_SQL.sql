/*

Cleaning Data in SQL Queries

*/

Select *
From PortfolioProject.dbo.NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select SaleDateConverted, Convert(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
Set SaleDate=CONVERT(Date,SaleDate)

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted=Convert(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data
Select *
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

Select T1.ParcelID,T1.PropertyAddress,T2.ParcelID, T2.PropertyAddress, ISNULL(T1.PropertyAddress, T2.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing T1
JOIN PortfolioProject.dbo.NashvilleHousing T2
ON T1.ParcelID=T2.ParcelID 
AND T1.[UniqueID ]<>T2.[UniqueID ]
Where T1.PropertyAddress is null

Update T1               
Set  PropertyAddress=ISNULL(T1.PropertyAddress, T2.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing T1
JOIN PortfolioProject.dbo.NashvilleHousing T2
ON T1.ParcelID=T2.ParcelID 
AND T1.[UniqueID ]<>T2.[UniqueID ]
Where T1.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing



Select 
Substring(PropertyAddress,1,CHARINDEX(',', PropertyAddress) -1) as Adress
, Substring(PropertyAddress,CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Adress


From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress=Substring(PropertyAddress,1,CHARINDEX(',', PropertyAddress) -1)

Alter Table PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255); 

Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitCity=Substring(PropertyAddress,CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) 


Select *

From PortfolioProject.dbo.NashvilleHousing

Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3) as adress
,PARSENAME(REPLACE(OwnerAddress,',','.'),2) as city
,PARSENAME(REPLACE(OwnerAddress,',','.'),1) as state
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter Table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255); 

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Alter Table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255); 

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select *

From PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct (SoldAsVacant),Count(SoldAsVacant)

From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
ORDER BY SoldAsVacant

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant='Y' Then 'Yes'
when SoldAsVacant='N' Then 'No'
ELSE SoldAsVacant
	END
From PortfolioProject.dbo.NashvilleHousing

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant=CASE WHEN SoldAsVacant='Y' Then 'Yes'
when SoldAsVacant='N' Then 'No'
ELSE SoldAsVacant
	END
-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates-CTE
With RowNumCTE AS(
Select *,
     ROW_NUMBER() Over(
	 PARTITION BY ParcelID,
	 PropertyAddress,
	 SalePrice,
	 SaleDate,
	 LegalReference
	 Order by
	 UniqueID
	 ) row_num
From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
SELECT *
FROM RowNumCTE
Where row_num>1
Order by PropertyAddress




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


