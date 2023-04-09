-- Data Cleaning in SQL

--Changed SaleDate to SaleDateConverted

Select SaleDateConverted, CONVERT(Date,SaleDate)
From NashvilleHousing

UPDATE NashvilleHousing
SET SaleDateConverted=CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
add SaleDateConverted Date

-----------------------------------------------------------------------------------------

-- Populate property address data

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID]<> b.[UniqueID]
where a.PropertyAddress is null

update a
set PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID]<> b.[UniqueID]
where a.PropertyAddress is null


------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns( Address, City, State)

Select PropertyAddress
From NashvilleHousing

Select 
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Addresss,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress)) as Addresses
From NashvilleHousing

UPDATE NashvilleHousing
SET PropertySplitAddress=SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
add PropertySplitAddress Nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress))

ALTER TABLE NashvilleHousing
add PropertySplitCity Nvarchar(255)

select PropertySplitAddress,PropertySplitCity
From NashvilleHousing




-- Owner address easier way than substring

select OwnerAddress
From NashvilleHousing

select 
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
From NashvilleHousing

UPDATE NashvilleHousing
SET OwnerSplitAddress=PARSENAME(Replace(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
add OwnerSplitAddress Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitCity =PARSENAME(Replace(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
add OwnerSplitCity Nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitState=PARSENAME(Replace(OwnerAddress,',','.'),1)

ALTER TABLE NashvilleHousing
add OwnerSplitState Nvarchar(255)

select OwnerSplitAddress,OwnerSplitCity,OwnerSplitState
From NashvilleHousing

----------------------------------------------------------------------------------------------------------------------
-- Change Y and N  and NO in 'SOLD as Vacant'Field
select Distinct(SoldAsVacant)
From NashvilleHousing

select SoldAsVacant, 
CASE when SoldAsVacant='Y' THEN 'Yes'
when SoldAsVacant='N' THEN 'No'
ELSE SoldAsVacant
End
From NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant=CASE when SoldAsVacant='Y' THEN 'Yes'
when SoldAsVacant='N' THEN 'No'
ELSE SoldAsVacant
End

---------------------------------------------------------------------------------------------------------------
--Remove Duplicates 
with RowNumCTE as(
Select *,ROW_NUMBER() OVER (
Partition by ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference
ORDER BY UniqueID) row_num
From NashvilleHousing
--ORDER BY ParcelID
)

SELECT * from RowNumCTE
WHERE row_num>1 

---------------------------------------------------------------------------------------------
--Delete Unused Columns 
SELECT *
From NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate














