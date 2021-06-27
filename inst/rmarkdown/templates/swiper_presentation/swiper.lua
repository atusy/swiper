-- let header.level == 1 as pages
function Header(header)
  if header.level == 1 then
    table.insert(header.classes, "swiper-slide")
  end
  return header
end


-- avoid pandoc from converting meta to content
function Meta(meta)
  TITLE = meta.title
  SUBTITLE = meta.subtitle
  AUTHOR = meta.author
  DATE = meta.date
  if not meta.title then
    return meta
  end
  if not meta.pagetitle then
    meta.pagetitle = meta.title
  end

  meta_new = {}
  for k,v in pairs(meta) do
    if k ~= "title" then
      meta_new[k] = v
    end
  end

  return meta_new
end

function blockify_inlines(k, v)
  local block = pandoc.Div(pandoc.Para({table.unpack(v)}))
  block.classes = {k}
  return block
end

-- add title page
function Pandoc(doc)
  if not TITLE then
    return doc
  end

  if DATE then
    table.insert(doc.blocks, 1, blockify_inlines('date', DATE))
  end

  if AUTHOR then
    if AUTHOR.t == "MetaInlines" then
      table.insert(doc.blocks, 1, blockify_inlines('author', AUTHOR))
    else
      for i, author in ipairs(AUTHOR) do
        table.insert(doc.blocks, 1, blockify_inlines('author', author))
      end
    end
  end

  if SUBTITLE then
    table.insert(doc.blocks, 1, blockify_inlines('subtitle', SUBTITLE))
  end

  local header = pandoc.Header(1, {table.unpack(TITLE)})
  header.classes = {'swiper-slide', 'title'}
  table.insert(doc.blocks, 1, header)

  return doc
end
