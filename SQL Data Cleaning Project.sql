/*

Cleaning data in SQL queries

*/

Select *
From PortfolioProject.dbo.nashvillehousing





--Standardize Data Format

Select SaledateConverted, CONVERT(Date, Saledate)
From PortfolioProject.dbo.nashvillehousing


Update NashvilleHousing
Set Saledate = CONVERT(Date, Saledate)

Alter Table NashvilleHousing
Add SaledateConverted Date;

Update NashvilleHousing
Set SaledateConverted = CONVERT(Date, Saledate)



--Populate Property Address Data

Select*
From PortfolioProject.dbo.nashvillehousing
Where Propertyaddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyAddress,  b.PropertyAddress)
From PortfolioProject.dbo.nashvillehousing a
Join PortfolioProject.dbo.nashvillehousing b
	on a.ParcelID = b.ParcelID 
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET propertyaddress = ISNULL(a.propertyAddress,  b.PropertyAddress)
From PortfolioProject.dbo.nashvillehousing a
Join PortfolioProject.dbo.nashvillehousing b
	on a.ParcelID = b.ParcelID 
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



--Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.nashvillehousing
--Where Propertyaddress is null
--Order by ParcelID

Select 
SUBSTRING(PropertyAddress, 1, Charindex(',', PropertyAddress) -1) as address
, SUBSTRING(PropertyAddress, Charindex(',', PropertyAddress) +1 , len(PropertyAddress)) as address

From PortfolioProject.dbo.nashvillehousing


Alter Table NashvilleHousing
Add PropertySplitaddress nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, Charindex(',', PropertyAddress) -1)


Alter Table NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, Charindex(',', PropertyAddress) +1 , len(PropertyAddress))


Select *
From PortfolioProject.dbo.nashvillehousing





Select owneraddress
From PortfolioProject.dbo.nashvillehousing


Select
parsename(replace(owneraddress, ',', '.') ,3)
, parsename(replace(owneraddress, ',', '.') ,2)
, parsename(replace(owneraddress, ',', '.') ,1)
From PortfolioProject.dbo.nashvillehousing



Alter Table NashvilleHousing
Add OwnerSplitaddress nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = parsename(replace(owneraddress, ',', '.') ,3)


Alter Table NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = parsename(replace(owneraddress, ',', '.') ,2)




Alter Table NashvilleHousing
Add OwnerSplitState nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = parsename(replace(owneraddress, ',', '.') ,1)


--Change Y and N to Yes and NO in "Sold as Vacant" field


Select Distinct(soldasvacant), count(soldasvacant)
From PortfolioProject.dbo.nashvillehousing
Group by soldasvacant
Order by 2



Select soldasvacant
,	Case When soldasvacant = 'Y' then 'Yes'
	When soldasvacant = 'N' then 'No'
	else soldasvacant
	end
From PortfolioProject.dbo.nashvillehousing

Update NashvilleHousing
Set SoldasVacant = Case When soldasvacant = 'Y' then 'Yes'
	When soldasvacant = 'N' then 'No'
	else soldasvacant
	end




	--Remove Duplicates

With RowNumCTE AS(
Select *, 
	Row_Number() Over (
	partition by Parcelid,
				Propertyaddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order By
					UniqueID
					) row_num
	

From PortfolioProject.dbo.nashvillehousing
--Order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by propertyaddress


Select *
From PortfolioProject.dbo.nashvillehousing




--Delete Unused Columns

Select *
From PortfolioProject.dbo.nashvillehousing

Alter table  PortfolioProject.dbo.nashvillehousing
Drop Column Owneraddress, taxdistrict, propertyaddress

Alter table  PortfolioProject.dbo.nashvillehousing
Drop Column saledate






