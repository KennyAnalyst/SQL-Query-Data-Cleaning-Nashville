--Data cleaning in SQL Query

Select *
from Nashville

-- standardize date format

select SaleDate, Convert (date, SaleDate) as Date
from [Nashville Housing].dbo.Nashville

Update Nashville
SET SaleDate = (date, SaleDate)


ALTER Table Nashville
add SaleDateConverted Date;


Update Nashville
SET SaleDateconverted = SaleDate 



--populate Property address date
select PropertyAddress
from Nashville
where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
From Nashville a
JOIN Nashville b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
set PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
From Nashville a
JOIN Nashville b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



/* Breaking address into individual columns
*/

Select PropertyAddress
from Nashville



/*Select 
Substring (PropertyAddress, 0, CHARINDEX ('HUNTER', PropertyAddress)) as Address
from Nashville*/


Select 
Substring (PropertyAddress, 0, CHARINDEX (',', PropertyAddress)) as Address,
Substring (PropertyAddress, CHARINDEX (',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
from Nashville

/*OR*/

Select 
Substring (PropertyAddress, 1, CHARINDEX (',', PropertyAddress)-1) as Address,
Substring (PropertyAddress, CHARINDEX (',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
from Nashville


ALTER Table Nashville
add PropertySplitAddress Nvarchar (255);


Update Nashville
SET PropertySplitAddress  = Substring (PropertyAddress, 1, CHARINDEX (',', PropertyAddress)-1)

ALTER Table Nashville
add PropertySplitRegion Nvarchar (255);


Update Nashville
SET PropertySplitRegion = Substring (PropertyAddress, CHARINDEX (',', PropertyAddress)+1, LEN(PropertyAddress))


select *
from Nashville

/* second method of spliting*/

Select
PARSENAME(Replace(OwnerAddress, ',', '.'),3),
PARSENAME(Replace(OwnerAddress, ',', '.'),2),
PARSENAME(Replace(OwnerAddress, ',', '.'),1)
from Nashville


ALTER Table Nashville
add OwnerSplitAddress Nvarchar (255);


Update Nashville
SET OwnerSplitAddress  = PARSENAME(Replace(OwnerAddress, ',', '.'),3)

ALTER Table Nashville
add OwnerSplitCity Nvarchar (255);


Update Nashville
SET OwnerSplitCity =PARSENAME(Replace(OwnerAddress, ',', '.'),2)


ALTER Table Nashville
add OwnerSplitState Nvarchar (255);

Update Nashville
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'),1)

Select Distinct (SoldAsVacant), Count(SoldAsVacant)
from Nashville
group by SoldAsVacant
order by 2


Select SoldAsVacant,
Case When SoldAsVacant = 'Y' Then 'Yes' 
When SoldAsVacant = 'N' then 'No'
Else SoldAsVacant
End
From Nashville

Update Nashville
Set SoldAsVacant =
Case When SoldAsVacant = 'Y' Then 'Yes' 
When SoldAsVacant = 'N' then 'No'
Else SoldAsVacant
End
From Nashville


/* Remove Duplicates*/

With RowNumrCTE As (
Select *, Row_Number () Over (
Partition By  	ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order by UniqueID
				) Row_Numr
from Nashville
---order by ParcelID 
)
Delete
from RowNumrCTE
 where Row_Numr >1
 --order by PropertyAddress



 
With RowNumrCTE As (
Select *, Row_Number () Over (
Partition By  	ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order by UniqueID
				) Row_Numr
from Nashville
---order by ParcelID 
)
Select *
from RowNumrCTE
 where Row_Numr >1

 --Delete unwanted columns
 Select *
 from Nashville

 Alter Table Nashville
 Drop column TaxDistrict, PropertySplitCity
 
 
