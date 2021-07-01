-- let header.level == 1 as pages
function Header(header)
  if header.level == 1 then
    table.insert(header.classes, "swiper-slide")
  end
  return header
end


function blockify_inlines(k, v)
  local block = pandoc.Div(pandoc.Para({table.unpack(v)}))
  block.classes = {k}
  return block
end


function create_title_section(doc)
  local TITLE = doc.meta.title
  if not TITLE then
    return doc
  end
  local SUBTITLE = doc.meta.subtitle
  local AUTHOR = doc.meta.author
  local DATE = doc.meta.date

  -- meta: remove title and add pagetitle
  meta_new = {}
  for k,v in pairs(doc.meta) do
    if k ~= "title" then
      meta_new[k] = v
    end
  end
  if not meta_new.pagetitle then
    meta_new.pagetitle = TITLE
  end
  doc.meta = meta_new

  -- doc: add title section
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


function configue_swiper(doc)
  local slide_level = doc.meta.swiper_options and doc.meta.swiper_options.slide_level or {'horizontal'}
  if type(slide_level) ~= "table" then
    slide_level = tostring(slide_level)
  elseif slide_level.t == "MetaInlines" then
    slide_level = pandoc.utils.stringify(slide_level)
  else
    local temp = {}
    for i, v in ipairs(slide_level) do
      table.insert(temp, pandoc.utils.stringify(v))
    end
    slide_level = temp
  end
  if slide_level == "1" then
    slide_level = {'horizontal'}
  elseif slide_level == "2" then
    slide_level = {'horizontal', 'vertical'}
  end
  for i, direction in ipairs(slide_level) do
    table.insert(doc.blocks, pandoc.RawBlock('html', table.concat({
      '<script type="application/json" id="swiper-presentation-level', i, '-config" aria-hidden="true">{',
      '"keyboard":{"enabled":true,"onlyInViewport":false},',
      '"direction":"', direction, '"',
      '}</script>'
    })))
  end
  return doc
end

-- add title page
function Pandoc(doc)
  if doc.blocks[1].t ~= "Header" then
    table.insert(doc.blocks, 1, pandoc.Header(1, pandoc.Str("")))
    table.insert(doc.blocks[1].classes, "swiper-slide")
  end

  doc = create_title_section(doc)
  doc.blocks = pandoc.utils.make_sections(true, 1, doc.blocks)
  doc = configue_swiper(doc)
  return doc
end
