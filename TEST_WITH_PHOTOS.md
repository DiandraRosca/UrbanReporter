# Testing Photos in Urban Reporter

## On Web (Chrome)
Photo upload is disabled on web because the File API works differently. To test the photo display feature:

1. Create a report without photos
2. Go to Supabase Dashboard → Table Editor → `reports`
3. Find your report
4. Edit the `photo_urls` column
5. Add a test image URL array like:
   ```json
   ["https://images.unsplash.com/photo-1580674285054-bed31e145f59?w=400"]
   ```
6. Save
7. Refresh the app - you'll see the photo in the report detail

## On Android Phone (Full Feature)
When running on a real Android device:
1. Photos work automatically
2. User can take a photo with camera OR choose from gallery
3. Photos upload to Supabase storage
4. Photos display in report details

## For Faculty Demo
**Recommended approach:**
1. Show the app working in Chrome for basic features (login, create reports, map, admin)
2. For photo demo, either:
   - Use the Supabase manual method above
   - OR run on Android phone to show real camera integration
   - OR mention "Photo upload works on mobile devices, disabled in web for demo"

The photo display code is fully implemented and working - it just needs actual photo URLs to display.
