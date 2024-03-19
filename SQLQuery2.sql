--Cleaning Data in SQL Queries

 select * from NashvilleHousing

 -- Standardize date format

Alter table NashvilleHousing
add SaleDateNew date;

update NashvilleHousing
set SaleDateNew = CONVERT(date, SaleDate)

select SaleDateNew
 from NashvilleHousing


--Populate Property Address data

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
 from NashvilleHousing a join NashvilleHousing b on a.ParcelID=b.ParcelID and a.[UniqueID ]<>b.[UniqueID ]
 where a.PropertyAddress is null

 update a
 set a.PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
 from NashvilleHousing a join NashvilleHousing b on a.ParcelID=b.ParcelID and a.[UniqueID ]<>b.[UniqueID ]
 where a.PropertyAddress is null

 select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
 from NashvilleHousing a join NashvilleHousing b on a.ParcelID=b.ParcelID and a.[UniqueID ]<>b.[UniqueID ]


 -- Breaking out Address into Individual columns( Address, city, State)

  select 
  SUBSTRING( PropertyAddress, 1, CHARINDEX(',',PropertyAddress )-1) as Address, 
  SUBSTRING( PropertyAddress, CHARINDEX(',',PropertyAddress )+1, LEN(PropertyAddress)) as Address
  from NashvilleHousing

  
Alter table NashvilleHousing
add PropertyNumAddress nvarchar(255);

update NashvilleHousing
set PropertyNumAddress = SUBSTRING( PropertyAddress, 1, CHARINDEX(',',PropertyAddress )-1)

Alter table NashvilleHousing
add PropertyCity nvarchar(255);

update NashvilleHousing
set PropertyCity = SUBSTRING( PropertyAddress, CHARINDEX(',',PropertyAddress )+1, LEN(PropertyAddress))

select * from NashvilleHousing

select OwnerAddress from NashvilleHousing


 select PARSENAME( REPLACE( OwnerAddress,',','.'),3),
PARSENAME(REPLACE( OwnerAddress,',','.'),2),
PARSENAME(REPLACE( OwnerAddress,',','.'),1)
 from NashvilleHousing

 Alter table NashvilleHousing
add OwnerNumAddress nvarchar(255);

update NashvilleHousing
set OwnerNumAddress = PARSENAME( REPLACE( OwnerAddress,',','.'),3)

Alter table NashvilleHousing
add OwnerCity nvarchar(255);

update NashvilleHousing
set OwnerCity = PARSENAME(REPLACE( OwnerAddress,',','.'),2)

Alter table NashvilleHousing
add OwnerState nvarchar(255);

update NashvilleHousing
set OwnerState = PARSENAME(REPLACE( OwnerAddress,',','.'),1)


-- Change Y and N to Yes and No in "sold as Vacant" field

 select SoldAsVacant from NashvilleHousing
 where SoldAsVacant in ('N', 'Y') 
  
  Update NashvilleHousing
  set SoldAsVacant='Yes'
  where SoldAsVacant='Y'

  Update NashvilleHousing
  set SoldAsVacant='No'
  where SoldAsVacant='N'

 --or
  Update NashvilleHousing
  set SoldAsVacant= case when SoldAsVacant='Y' then 'Yes'
  when SoldAsVacant='N' then 'No'
  else SoldAsVacant
end


-- remove duplicates

 with RowNumCTE as(
 select *,
 ROW_NUMBER() over (partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference order by UniqueID) row_num 
from NashvilleHousing)
delete
from RowNumCTE
where row_num>1


-- delete Unused columns


select * from NashvilleHousing 

Alter table NashvilleHousing
drop column SaleDate, PropertyAddress, OwnerAddress