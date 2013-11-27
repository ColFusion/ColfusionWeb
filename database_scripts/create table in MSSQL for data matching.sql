USE colfusion_relationships_columns
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[transformationDistinctValue](
[transformation] [nvarchar](400) NOT NULL,
[value] [nvarchar](400) NOT NULL
) ON [PRIMARY]

GO

CREATE NONCLUSTERED INDEX [IX_transformationDistinctValue] ON [dbo].[transformationDistinctValue] 
(
[transformation] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO