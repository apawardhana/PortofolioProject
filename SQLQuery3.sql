-- Cleaning data with SQL
 /* ------------------------------------------------------------------------------------------------------------------------------------ */
select *
from NashvilleHousing


-- standarize sale date

select SaleDate, SaleDateConverted, CONVERT(date,SaleDate)
from NashvilleHousing

update NashvilleHousing
set SaleDate = CONVERT(date,SaleDate)

alter table NashvilleHousing
add SaleDateConverted date;

update NashvilleHousing
set SaleDateConverted = CONVERT(date,SaleDate)


-- populated property address data

select *
from NashvilleHousing
--where PropertyAddress is null
order by ParcelID


select 
	a.ParcelID,a.PropertyAddress,
	b.ParcelID,b.PropertyAddress,
	-- Penggunakan fungsi ISNULL dengan mencocokan antara property address a dan b jika  a adalah null
	ISNULL(a.PropertyAddress,b.PropertyAddress) as 'Null Checking Address' 
from 
	NashvilleHousing a
join 
	NashvilleHousing b
	on 
		a.ParcelID = b.ParcelID
	and
		a.[UniqueID ] <> b.[UniqueID ]
where
	a.PropertyAddress is null

-- update data yang null
-- kita update table (jika sudah di aliasing maka gunakan alias nya)
update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from 
	NashvilleHousing a
join 
	NashvilleHousing b
	on 
		a.ParcelID = b.ParcelID
	and
		a.[UniqueID ] <> b.[UniqueID ]
where
	a.PropertyAddress is null


/* ------------------------------------------------------------------------------------------------------------------------------------ */
-- memisahkan address ke kolom yang baru atau terpisah (address, city, state)

select 
	-- Address
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 ) as Address,
	-- City
	SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) as City
from NashvilleHousing

-- memisahkan address dari city dengan membuat table "PropertySplitAddress"
alter table NashvilleHousing
add PropertySplitAddress nvarchar(255);

update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 )

-- Memisahkan City dengan membuat table "PropertySplitCity"
alter table NashvilleHousing
add PropertySplitCity nvarchar(255);

update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))

-- Memeriksa apakah data yang di pisah masih sesuai atau tidak
select PropertyAddress, PropertySplitAddress,PropertySplitCity
from NashvilleHousing


-- Memisahkan data untuk owner address
select OwnerAddress
from NashvilleHousing


-- Menggunakan fungsi PARSENAME
select
	-- Address
	PARSENAME(Replace(OwnerAddress,',','.'),3) as 'Address',
	-- City
	PARSENAME(Replace(OwnerAddress,',','.'),2) as 'City',
	-- State
	PARSENAME(Replace(OwnerAddress,',','.'),1) as 'State'
from NashvilleHousing


-- memisahkan 1 table owner address menjadi 3 yaitu "OwnerAddress", "OwnerCity", "OwnerState"

-- OwnerAddress
alter table 
	NashvilleHousing
add 
	OwnerSplitAddress nvarchar(255);

update 
	NashvilleHousing
set 
	OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

-- Owner City

alter table 
	NashvilleHousing
add 
	OwnerSplitCity nvarchar(255);

update 
	NashvilleHousing
set 
	OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

-- Owner State

alter table 
	NashvilleHousing
add 
	OwnerSplitState nvarchar(255);

update 
	NashvilleHousing
set 
	OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)


-- Memastikan apakah data sudah dipisahkan dengan benar

select OwnerAddress, OwnerSplitAddress, OwnerSplitCity, OwnerSplitState
from NashvilleHousing
 /* ------------------------------------------------------------------------------------------------------------------------------------ */

 -- Merubah Nilai SoldAsVacant dari Y dan N menjadi Yes dan No

 -- menggunakan fungsi distinct dan count untuk melihat berapa jumlah dari Y,N,Yes,No

 select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
 from NashvilleHousing
 group by SoldAsVacant
 order by 2

 -- merubah nilai nya
 select 
	SoldAsVacant,
CASE when SoldAsVacant = 'Y' THEN 'Yes'
	 When SoldAsVacant = 'N' THEN 'No'
	 else SoldAsVacant
	 end
 from NashvilleHousing
 --where SoldAsVacant = 'N'
 

-- update nilai SoldAsVacant seperti yang sudah kita jalankan
update NashvilleHousing
set SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
	 When SoldAsVacant = 'N' THEN 'No'
	 else SoldAsVacant
	 end

 /* ------------------------------------------------------------------------------------------------------------------------------------ */

-- Menghapus data dup
with RowNumDupCTE as (
SELECT *,
	ROW_NUMBER() over(
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by
					UniqueID
					) row_num
From NashvilleHousing
)

select *
from RowNumDupCTE
where row_num > 1
order by PropertyAddress

 /* ------------------------------------------------------------------------------------------------------------------------------------ */

 -- Menghapus column yang tidak kita gunakan

 select *
 from NashvilleHousing

 -- kita sudah split PropertyAddress dan OwnerAddress jadi ini yang akan kita hapus dan kita juga akan menghapus
 -- TaxDistrict dan SaleDate

alter table NashvilleHousing
drop column PropertyAddress, OwnerAddress, TaxDistrict, SaleDate

alter table NashvilleHousing
drop column SaleDate






