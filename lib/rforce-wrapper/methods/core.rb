module RForce
  module Wrapper
    module ApiMethods
      module CoreMethods
        def convertLead(*leadConverts)
        end

        def create(*sObjects)
          params = sObjects.flatten.map { |sobj| [:sObjects, sobj] }.flatten
          make_api_call :create, params
        end

        def delete(*ids)
          params = ids.flatten.map { |id| [:ids, id] }.flatten
          make_api_call :delete, params
        end

        def emptyRecycleBin(*ids)
          params = ids.flatten.map { |id| [:ids, id] }.flatten
          make_api_call :emptyRecycleBin, params
        end

        def getDeleted(sObjectType, startDate, endDate)
        end

        def getUpdated(sObjectType, startDate, endDate)
        end

        def invalidateSessions(*sessionIds)
          params = sessionIds.flatten.map { |id| [:sessionIds, id] }.flatten
          make_api_call :invalidateSessions, params
        end

        def logout
          make_api_call :logout
        end

        def merge(*mergeRequests)
        end

        def process(*processRequests)
        end

        def query(queryString)
        end

        def queryAll(queryString)
        end

        def queryMore(queryLocator)
        end

        # http://www.salesforce.com/us/developer/docs/api/Content/sforce_api_calls_retrieve.htm
        def retrieve(fieldList, sObjectType, *ids)
          params = [ :fieldList, fieldList, :sObjectType, sObjectType ]
          params += ids.flatten.map { |id| [:ids, id] }.flatten
          make_api_call :retrieve, params
        end

        def search(searchString)
        end

        def undelete(*ids)
        end

        def update(*sObjects)
        end

        def upsert(externalIdFieldName, *sObjects)
        end
      end
    end
  end
end
