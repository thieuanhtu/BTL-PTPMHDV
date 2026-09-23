CREATE DATABASE QuanLyQuanCafe;
GO

USE QuanLyQuanCafe;
GO

-- 1. Bảng Người dùng / Nhân viên (user)
CREATE TABLE [dbo].[user](
	[user_id] [varchar](50) NOT NULL,
	[hoten] [nvarchar](150) NULL,
	[ngaysinh] [date] NULL,
	[diachi] [nvarchar](250) NULL,
	[gioitinh] [nvarchar](30) NULL,
	[email] [varchar](150) NULL,
	[taikhoan] [varchar](30) NULL,
	[matkhau] [varchar](60) NULL,
	[role] [varchar](30) NULL, -- 'Admin', 'ThuNgan', 'PhucVu', 'PhaChe'
	[image_url] [varchar](300) NULL,
 CONSTRAINT [PK_user] PRIMARY KEY CLUSTERED ([user_id] ASC)
) ON [PRIMARY]
GO

-- 2. Bảng Danh mục đồ uống (item_group)
CREATE TABLE [dbo].[item_group](
	[parent_item_group_id] [varchar](50) NULL,
	[item_group_id] [varchar](50) NOT NULL,
	[item_group_name] [nvarchar](250) NULL,
	[seq_num] [smallint] NULL,
	[url] [varchar](150) NULL,
 CONSTRAINT [PK_item_group] PRIMARY KEY CLUSTERED ([item_group_id] ASC)
) ON [PRIMARY]
GO

-- 3. Bảng Đồ uống / Sản phẩm (item)
CREATE TABLE [dbo].[item](
	[item_id] [varchar](50) NOT NULL,
	[item_group_id] [varchar](50) NULL,
	[item_name] [nvarchar](150) NULL,
	[item_image] [varchar](250) NULL,
	[item_price] [float] NULL,
 CONSTRAINT [PK_item] PRIMARY KEY CLUSTERED ([item_id] ASC)
) ON [PRIMARY]
GO

-- 4. Bảng Quản lý Bàn (cafe_table)
CREATE TABLE [dbo].[cafe_table](
	[table_id] [varchar](50) NOT NULL,
	[table_name] [nvarchar](100) NULL,
	[status] [nvarchar](30) DEFAULT N'Trống', -- 'Trống', 'Đang phục vụ'
 CONSTRAINT [PK_cafe_table] PRIMARY KEY CLUSTERED ([table_id] ASC)
) ON [PRIMARY]
GO

-- 5. Bảng Hóa đơn / Order (hoa_don)
CREATE TABLE [dbo].[hoa_don](
	[ma_hoa_don] [varchar](50) NOT NULL,
	[table_id] [varchar](50) NULL,
	[ho_ten] [nvarchar](150) NULL, -- Tên khách hàng hoặc nhân viên tạo
	[dia_chi] [nvarchar](250) NULL, -- Ghi chú hoặc địa chỉ mang đi
	[ngay_tao] [datetime] DEFAULT GETDATE(),
 CONSTRAINT [PK_hoa_don] PRIMARY KEY CLUSTERED ([ma_hoa_don] ASC)
) ON [PRIMARY]
GO

-- 6. Bảng Chi tiết hóa đơn / Món gọi theo bàn (chi_tiet_hoa_don)
CREATE TABLE [dbo].[chi_tiet_hoa_don](
	[ma_chi_tiet] [varchar](50) NOT NULL,
	[ma_hoa_don] [varchar](50) NULL,
	[item_id] [varchar](50) NULL,
	[so_luong] [int] NULL,
	[ghi_chu_mon] [nvarchar](250) NULL, -- Ví dụ: Ít đá, nhiều đường
 CONSTRAINT [PK_chi_tiet_hoa_don] PRIMARY KEY CLUSTERED ([ma_chi_tiet] ASC)
) ON [PRIMARY]
GO

-- Thiết lập Khóa ngoại (Foreign Keys)
ALTER TABLE [dbo].[item] WITH CHECK ADD CONSTRAINT [FK_item_item_group] FOREIGN KEY([item_group_id])
REFERENCES [dbo].[item_group] ([item_group_id])
GO

ALTER TABLE [dbo].[chi_tiet_hoa_don] WITH CHECK ADD CONSTRAINT [FK_chi_tiet_hoa_don_hoa_don] FOREIGN KEY([ma_hoa_don])
REFERENCES [dbo].[hoa_don] ([ma_hoa_don]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[chi_tiet_hoa_don] WITH CHECK ADD CONSTRAINT [FK_chi_tiet_hoa_don_item] FOREIGN KEY([item_id])
REFERENCES [dbo].[item] ([item_id])
GO

ALTER TABLE [dbo].[hoa_don] WITH CHECK ADD CONSTRAINT [FK_hoa_don_table] FOREIGN KEY([table_id])
REFERENCES [dbo].[cafe_table] ([table_id])
GO

-- PHẦN 2: NHẬP DỮ LIỆU 

INSERT INTO [dbo].[item_group] ([parent_item_group_id], [item_group_id], [item_group_name], [seq_num], [url]) 
VALUES 
(NULL, 'g1', N'Cà phê máy & truyền thống', 1, NULL),
(NULL, 'g2', N'Trà sữa & Trà trái cây', 2, NULL),
(NULL, 'g3', N'Đồ ăn vặt & Bánh ngọt', 3, NULL);
GO

-- 2. Thêm Sản phẩm / Đồ uống
INSERT INTO [dbo].[item] ([item_id], [item_group_id], [item_name], [item_image], [item_price]) 
VALUES 
('it1', 'g1', N'Cà phê đen đá', 'assets/img/cafe_den.jpg', 20000),
('it2', 'g1', N'Cà phê sữa đá', 'assets/img/cafe_sua.jpg', 25000),
('it3', 'g1', N'Latte Macchiato', 'assets/img/latte.jpg', 45000),
('it4', 'g2', N'Trà đào cam sả', 'assets/img/tra_dao.jpg', 35000),
('it5', 'g2', N'Trà sữa trân châu đường đen', 'assets/img/trasua.jpg', 40000),
('it6', 'g3', N'Bánh tiramisu', 'assets/img/tiramisu.jpg', 30000);
GO

-- 3. Thêm Bàn quán cafe
INSERT INTO [dbo].[cafe_table] ([table_id], [table_name], [status]) 
VALUES 
('tb1', N'Bàn 01 (Tầng 1)', N'Trống'),
('tb2', N'Bàn 02 (Tầng 1)', N'Trống'),
('tb3', N'Bàn 03 (Sân vườn)', N'Trống'),
('tb4', N'Bàn VIP 01', N'Trống');
GO

-- 4. Thêm Người dùng / Nhân viên / Admin
INSERT INTO [dbo].[user] ([user_id], [hoten], [ngaysinh], [diachi], [gioitinh], [email], [taikhoan], [matkhau], [role], [image_url]) 
VALUES 
('u1', N'Nguyễn Văn Quản Trị', '1990-01-01', N'Hưng Yên', N'Nam', 'admin@cafe.com', 'admin', 'admin123', 'Admin', NULL),
('u2', N'Trần Thị Thu Ngân', '1998-05-12', N'Hà Nội', N'Nữ', 'thungan@cafe.com', 'thungan', '123456', 'ThuNgan', NULL),
('u3', N'Lê Văn Phục Vụ', '2002-10-20', N'Hưng Yên', N'Nam', 'phucvu@cafe.com', 'phucvu', '123456', 'PhucVu', NULL);
GO

-- 5. Thêm Hóa đơn mẫu & Chi tiết hóa đơn
INSERT INTO [dbo].[hoa_don] ([ma_hoa_don], [table_id], [ho_ten], [dia_chi], [ngay_tao]) 
VALUES ('hd1', 'tb1', N'Khách lẻ Bàn 01', N'Gọi tại bàn', GETDATE());

INSERT INTO [dbo].[chi_tiet_hoa_don] ([ma_chi_tiet], [ma_hoa_don], [item_id], [so_luong], [ghi_chu_mon]) 
VALUES ('ct1', 'hd1', 'it2', 2, N'Nhiều sữa'), ('ct2', 'hd1', 'it4', 1, N'Ít đá');
GO

-- PHẦN 3: HỆ THỐNG STORED PROCEDURES (CRUD & OPENJSON)

-- 1. Quản lý Đồ uống (Item)
CREATE PROCEDURE [dbo].[sp_item_all]
AS
    BEGIN
        SELECT item_id, item_group_id, item_image, item_name, item_price FROM item;
    END;
GO

CREATE PROCEDURE [dbo].[sp_item_create]
(
    @item_id VARCHAR(50), 
    @item_group_id VARCHAR(50), 
    @item_image VARCHAR(250), 
    @item_name NVARCHAR(150),    
    @item_price FLOAT  
)
AS
    BEGIN
        INSERT INTO item (item_id, item_group_id, item_image, item_name, item_price)
        VALUES (@item_id, @item_group_id, @item_image, @item_name, @item_price);
        SELECT '';
    END;
GO

CREATE PROCEDURE [dbo].[sp_item_search] 
(
    @page_index INT, 
    @page_size INT,
    @item_group_id NVARCHAR(50),
    @item_name NVARCHAR(150)
)
AS
    BEGIN
        DECLARE @RecordCount BIGINT;
        IF(@page_size <> 0)
            BEGIN
                SET NOCOUNT ON;
                SELECT (ROW_NUMBER() OVER(ORDER BY item_name ASC)) AS RowNumber, 
                      i.item_id, i.item_group_id, i.item_name, i.item_image, i.item_price
                INTO #Results1
                FROM [item] AS i
                WHERE (@item_name = '' OR i.item_name LIKE N'%'+@item_name+'%') AND						
                      (@item_group_id IS NULL OR @item_group_id = '' OR i.item_group_id = @item_group_id);                   
                
                SELECT @RecordCount = COUNT(*) FROM #Results1;
                SELECT *, @RecordCount AS RecordCount FROM #Results1
                WHERE ROWNUMBER BETWEEN (@page_index - 1) * @page_size + 1 AND (((@page_index - 1) * @page_size + 1) + @page_size) - 1
                      OR @page_index = -1;
                DROP TABLE #Results1; 
            END;
    END;
GO

-- 2. Quản lý Hóa đơn / Order (Master-Detail với OPENJSON chuẩn style của thầy)
CREATE PROCEDURE [dbo].[sp_hoa_don_create]
(
    @ma_hoa_don VARCHAR(50), 
    @table_id VARCHAR(50),
    @ho_ten NVARCHAR(150), 
    @dia_chi NVARCHAR(250),  
    @listjson_chitiet NVARCHAR(MAX)
)
AS
    BEGIN
        INSERT INTO hoa_don (ma_hoa_don, table_id, ho_ten, dia_chi, ngay_tao)
        VALUES (@ma_hoa_don, @table_id, @ho_ten, @dia_chi, GETDATE());

        IF @table_id IS NOT NULL
        BEGIN
            UPDATE cafe_table SET status = N'Đang phục vụ' WHERE table_id = @table_id;
        END

        IF (@listjson_chitiet IS NOT NULL)
        BEGIN
            INSERT INTO chi_tiet_hoa_don (ma_chi_tiet, ma_hoa_don, item_id, so_luong)
            SELECT 
                JSON_VALUE(p.value, '$.ma_chi_tiet'), 
                @ma_hoa_don, 
                JSON_VALUE(p.value, '$.item_id'), 
                JSON_VALUE(p.value, '$.so_luong')    
            FROM OPENJSON(@listjson_chitiet) AS p;
        END;
        SELECT '';
    END;
GO

CREATE PROCEDURE [dbo].[sp_hoa_don_delete]
(
    @ma_hoa_don VARCHAR(50)
)
AS
    BEGIN
        -- Cập nhật lại trạng thái bàn về Trống trước khi xóa hóa đơn
        DECLARE @tbl VARCHAR(50);
        SELECT @tbl = table_id FROM hoa_don WHERE ma_hoa_don = @ma_hoa_don;
        IF @tbl IS NOT NULL
        BEGIN
            UPDATE cafe_table SET status = N'Trống' WHERE table_id = @tbl;
        END

		DELETE FROM [chi_tiet_hoa_don] WHERE ma_hoa_don = @ma_hoa_don;
		DELETE FROM [hoa_don] WHERE ma_hoa_don = @ma_hoa_don;
        SELECT '';
    END;
GO

CREATE PROCEDURE [dbo].[sp_hoa_don_search] 
(
    @page_index INT, 
    @page_size INT,
    @hoten NVARCHAR(150)
)
AS
    BEGIN
        DECLARE @RecordCount BIGINT;
        IF(@page_size <> 0)
            BEGIN
                SET NOCOUNT ON;
                SELECT (ROW_NUMBER() OVER(ORDER BY ngay_tao DESC)) AS RowNumber, 
                       h.ma_hoa_don, h.table_id, h.ho_ten, h.dia_chi, h.ngay_tao                               
                INTO #Results1
                FROM [hoa_don] AS h
                WHERE (@hoten = '' OR h.ho_ten LIKE N'%'+@hoten+'%');                  
                
                SELECT @RecordCount = COUNT(*) FROM #Results1;
                SELECT *, @RecordCount AS RecordCount FROM #Results1
                WHERE ROWNUMBER BETWEEN (@page_index - 1) * @page_size + 1 AND (((@page_index - 1) * @page_size + 1) + @page_size) - 1
                      OR @page_index = -1;
                DROP TABLE #Results1; 
            END;
    END;
GO