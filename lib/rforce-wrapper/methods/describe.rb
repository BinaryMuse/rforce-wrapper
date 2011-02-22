module RForce
  module Wrapper
    module DescribeMethods

      def describeDataCategoryGroups(*sObjectTypes)
      end

      def describeDataCategoryGroupStructures(*dataCategoryGroupSObjectTypePairs, topCategoriesOnly)
      end

      def describeGlobal
      end

      def describeLayout(sObjectType, *recordTypeIds)
      end

      def describeSObject(sObjectType)
        describeSObjects(sObjectType)
      end

      def describeSObjects(*sObjectTypes)
        params = sObjectTypes.flatten.map { |type| [:sObjectType, type] }.flatten
        make_api_call :describeSObjects, params
      end

      def describeSoftphoneLayout
      end

      def describeTabs
      end

    end
  end
end
